import argparse
from datetime import datetime, timedelta
from decimal import Decimal
import random

try:
    from .anomaly import detect
    from .billing import TZ
    from .database import connect
except ImportError:
    from anomaly import detect
    from billing import TZ
    from database import connect


def simulate(conn, user_id, charger_id, start, energy, minutes):
    if start.tzinfo is None or minutes <= 0 or energy <= 0:
        raise ValueError('Início deve ter fuso; duração e energia devem ser positivos')
    conn.execute('SELECT pg_advisory_xact_lock(260901)')
    user = conn.execute('''SELECT * FROM usuario WHERE id=%s AND acesso_ativo
        AND perfil='morador' AND rfid_tag IS NOT NULL AND unidade_id IS NOT NULL''',
        (user_id,)).fetchone()
    charger = conn.execute('SELECT * FROM carregador WHERE id=%s', (charger_id,)).fetchone()
    if user is None or charger is None:
        raise ValueError('Usuário ativo com RFID ou carregador não encontrado')
    end = start + timedelta(minutes=minutes)
    if conn.execute('''SELECT 1 FROM sessao WHERE carregador_id=%s
        AND inicio < %s AND (fim IS NULL OR fim > %s) LIMIT 1''',
        (charger_id, end, start)).fetchone():
        raise ValueError('Carregador ocupado neste intervalo')
    if conn.execute('''SELECT 1 FROM fatura WHERE unidade_id=%s AND competencia=%s
        AND status='paga' ''', (user['unidade_id'], start.astimezone(TZ).date().replace(day=1))).fetchone():
        raise ValueError('Competência já paga para esta unidade')
    initial = conn.execute('''SELECT coalesce(max(energia_acumulada_kwh),0) AS value
        FROM meter_value mv JOIN sessao s ON s.id=mv.sessao_id WHERE carregador_id=%s''',
        (charger_id,)).fetchone()['value']
    seed_meter = conn.execute('SELECT coalesce(max(meter_fim_kwh),0) AS value FROM sessao WHERE carregador_id=%s',
                              (charger_id,)).fetchone()['value']
    initial = max(initial, seed_meter)
    energy = Decimal(str(energy)).quantize(Decimal('0.001'))
    if energy <= 0:
        raise ValueError('Energia mínima: 0.001 kWh')
    if energy * 60 / minutes > Decimal('999.999'):
        raise ValueError('Potência simulada excede o limite de armazenamento')
    session_id = conn.execute('''INSERT INTO sessao (usuario_id, carregador_id, inicio, meter_inicio_kwh)
        VALUES (%s,%s,%s,%s) RETURNING id''', (user_id, charger_id, start, initial)).fetchone()['id']
    power = energy * 60 / minutes
    with conn.cursor() as cur:
        cur.executemany('''INSERT INTO meter_value (sessao_id, momento, potencia_kw, tensao_v,
            corrente_a, energia_acumulada_kwh) VALUES (%s,%s,%s,%s,%s,%s)''',
            [(session_id, start + timedelta(minutes=i), power, 220, power * 1000 / 220,
              (initial + energy * i / minutes).quantize(Decimal('0.001')))
             for i in range(minutes + 1)])
    mean = conn.execute('''SELECT avg(energia_kwh) AS value FROM sessao WHERE usuario_id=%s
        AND inicio < %s AND status_revisao IN ('normal','aprovada') AND status <> 'em_andamento' ''',
        (user_id, start)).fetchone()['value']
    score, review, reason = detect(energy, Decimal(minutes) / 60, start.astimezone(TZ).hour,
                                   user['capacidade_bateria_kwh'], mean)
    result = conn.execute('''UPDATE sessao SET fim=%s, meter_fim_kwh=%s, status='concluida',
        motivo_termino='EVDisconnected', anomaly_score=%s, status_revisao=%s, motivo_alerta=%s
        WHERE id=%s RETURNING *''', (end, initial + energy, score, review, reason, session_id)).fetchone()
    conn.execute('''UPDATE fatura SET status='aberta' WHERE unidade_id=%s AND competencia=%s
        AND status <> 'paga' ''', (user['unidade_id'], start.astimezone(TZ).date().replace(day=1)))
    return result


def main():
    parser = argparse.ArgumentParser(description='Gera sessões e MeterValues e executa a IA')
    parser.add_argument('--quantidade', type=int, default=5)
    parser.add_argument('--inicio', default='2026-10-01T08:00:00-03:00')
    parser.add_argument('--seed', type=int, default=42)
    args = parser.parse_args()
    if not 1 <= args.quantidade <= 1000:
        parser.error('--quantidade deve estar entre 1 e 1000')
    rng = random.Random(args.seed)
    start = datetime.fromisoformat(args.inicio)
    with connect() as conn:
        users = conn.execute("SELECT id FROM usuario WHERE acesso_ativo AND perfil='morador' AND rfid_tag IS NOT NULL AND unidade_id IS NOT NULL").fetchall()
        charger = conn.execute('SELECT * FROM carregador ORDER BY id LIMIT 1').fetchone()
        if not users or not charger:
            raise ValueError('Carregador e usuários devem estar cadastrados')
        for index in range(args.quantidade):
            minutes = rng.randint(60, 300)
            power = float(charger['potencia_nominal_kw']) * rng.uniform(0.65, 1.0)
            result = simulate(conn, rng.choice(users)['id'], charger['id'],
                              start + timedelta(days=index), round(power * minutes / 60, 3), minutes)
            print(f"Sessão {result['id']}: {result['energia_kwh']} kWh, {result['status_revisao']}")


if __name__ == '__main__':
    main()
