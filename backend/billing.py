from datetime import datetime, timedelta
from decimal import Decimal, ROUND_HALF_UP
from zoneinfo import ZoneInfo

TZ = ZoneInfo('America/Sao_Paulo')
ZERO = Decimal('0')


def money(value):
    return value.quantize(Decimal('0.01'), rounding=ROUND_HALF_UP)


def peak_seconds(start, end, peak_start, peak_end):
    if end <= start or peak_start == peak_end:
        return ZERO
    day = start.astimezone(TZ).date() - timedelta(days=1)
    last = end.astimezone(TZ).date()
    total = ZERO
    while day <= last:
        left = datetime.combine(day, peak_start, TZ)
        right = datetime.combine(day + timedelta(days=peak_end < peak_start), peak_end, TZ)
        overlap = (min(end, right) - max(start, left)).total_seconds()
        total += Decimal(str(max(0, overlap)))
        day += timedelta(days=1)
    return total


def peak_energy(session, readings, tariff):
    start, end = session['inicio'], session['fim']
    if end is None or end <= start:
        return ZERO
    points = [(start, session['meter_inicio_kwh'])]
    previous = session['meter_inicio_kwh']
    for reading in sorted(readings, key=lambda r: r['momento']):
        energy = reading['energia_acumulada_kwh']
        if (energy is not None and start < reading['momento'] < end
                and previous <= energy <= session['meter_fim_kwh']):
            points.append((reading['momento'], energy))
            previous = energy
    points.append((end, session['meter_fim_kwh']))
    total = ZERO
    for (left, initial), (right, final) in zip(points, points[1:]):
        duration = Decimal(str((right - left).total_seconds()))
        if duration > 0:
            total += (final - initial) * peak_seconds(
                left, right, tariff['ponta_inicio'], tariff['ponta_fim']) / duration
    return total


def generate(conn, month):
    conn.execute('SELECT pg_advisory_xact_lock(260901)')
    tariff = conn.execute('SELECT * FROM tarifa WHERE competencia = %s', (month,)).fetchone()
    if tariff is None:
        from fastapi import HTTPException
        raise HTTPException(404, 'Tarifa não cadastrada para a competência')
    units = conn.execute('''SELECT un.id, count(u.id) FILTER
        (WHERE u.acesso_ativo AND u.perfil = 'morador' AND u.rfid_tag IS NOT NULL) AS ativos
        FROM unidade un LEFT JOIN usuario u ON u.unidade_id = un.id
        GROUP BY un.id ORDER BY un.id''').fetchall()
    active_count = sum(u['ativos'] for u in units)
    fixed = {u['id']: ZERO for u in units}
    if active_count:
        cents = int(money(tariff['custo_fixo_mensal']) * 100)
        share, remainder = divmod(cents, active_count)
        for unit in units:
            extra = min(remainder, unit['ativos'])
            fixed[unit['id']] = Decimal(share * unit['ativos'] + extra) / 100
            remainder -= extra
    sessions = conn.execute('''SELECT s.*, u.unidade_id FROM sessao s
        JOIN usuario u ON u.id = s.usuario_id
        WHERE s.inicio >= %s::date AND s.inicio < %s::date + interval '1 month'
        ORDER BY s.id''', (month, month)).fetchall()
    readings = conn.execute('''SELECT mv.* FROM meter_value mv JOIN sessao s ON s.id=mv.sessao_id
        WHERE s.inicio >= %s::date AND s.inicio < %s::date + interval '1 month'
        ORDER BY mv.momento''', (month, month)).fetchall()
    by_session = {}
    for reading in readings:
        by_session.setdefault(reading['sessao_id'], []).append(reading)
    for unit in units:
        own = [s for s in sessions if s['unidade_id'] == unit['id']]
        if not own and not unit['ativos']:
            continue
        eligible = [s for s in own if s['status'] != 'em_andamento'
                    and s['energia_kwh'] is not None and s['status_revisao'] != 'estornada']
        blocked = any(s['status_revisao'] in ('em_revisao', 'pendente')
                      or s['status'] == 'em_andamento' for s in own)
        energy = sum((s['energia_kwh'] for s in eligible), ZERO)
        peak = sum((peak_energy(s, by_session.get(s['id'], []), tariff) for s in eligible), ZERO)
        variable = money(energy * tariff['tarifa_base_kwh'] + peak * tariff['adicional_ponta_kwh'])
        value_fixed = fixed[unit['id']]
        conn.execute('''INSERT INTO fatura (unidade_id, competencia, num_sessoes, kwh_total,
            valor_variavel, valor_fixo, valor_total, status) VALUES (%s,%s,%s,%s,%s,%s,%s,%s)
            ON CONFLICT (unidade_id, competencia) DO UPDATE SET
            num_sessoes=EXCLUDED.num_sessoes, kwh_total=EXCLUDED.kwh_total,
            valor_variavel=EXCLUDED.valor_variavel, valor_fixo=EXCLUDED.valor_fixo,
            valor_total=EXCLUDED.valor_total, status=EXCLUDED.status, gerada_em=now()
            WHERE fatura.status <> 'paga' ''',
            (unit['id'], month, len(eligible), energy, variable, value_fixed,
             variable + value_fixed, 'aberta' if blocked else 'fechada'))
