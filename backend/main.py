from contextlib import asynccontextmanager
from datetime import date, datetime
from decimal import Decimal
import logging
import re
from typing import Literal
import json
from pathlib import Path

from fastapi import Depends, FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from pydantic import BaseModel, Field, AwareDatetime
import psycopg

try:
    from .database import get_db
    from .billing import generate
    from .anomaly import load_model
    from .simulator import simulate
except ImportError:
    from database import get_db
    from billing import generate
    from anomaly import load_model
    from simulator import simulate


@asynccontextmanager
async def lifespan(app):
    load_model()
    yield


app = FastAPI(title='EV ChargeOps', lifespan=lifespan)
app.add_middleware(CORSMiddleware, allow_origins=['http://localhost:5173'],
                   allow_methods=['GET', 'POST'], allow_headers=['Content-Type'])


@app.exception_handler(psycopg.OperationalError)
async def database_unavailable(request, exc):
    logging.getLogger(__name__).exception('PostgreSQL indisponível', exc_info=exc)
    return JSONResponse(status_code=503, content={'detail': 'PostgreSQL indisponível'})


def month(competencia: str):
    if not re.fullmatch(r'\d{4}-(0[1-9]|1[0-2])', competencia):
        raise HTTPException(422, 'Competência deve ter formato YYYY-MM')
    try:
        return date.fromisoformat(competencia + '-01')
    except ValueError:
        raise HTTPException(422, 'Competência inválida')


class Consumption(BaseModel):
    unidade: str
    competencia: str
    num_sessoes: int
    kwh_total: float


class Invoice(Consumption):
    valor_variavel: float
    valor_fixo: float
    valor_total: float
    status: Literal['aberta', 'fechada', 'paga']


class Alert(BaseModel):
    id: int
    usuario: str
    unidade: str
    inicio: datetime
    fim: datetime | None
    energia_kwh: float | None
    anomaly_score: float | None
    motivo_alerta: str | None


class Decision(BaseModel):
    decisao: Literal['aprovada', 'estornada']


class Simulation(BaseModel):
    usuario_id: int = Field(gt=0)
    carregador_id: int = Field(gt=0)
    inicio: AwareDatetime
    energia_kwh: Decimal = Field(gt=0, le=500)
    duracao_minutos: int = Field(gt=0, le=1440)


@app.get('/consumo-mensal', response_model=list[Consumption])
def consumption(competencia: str, conn=Depends(get_db, scope='function')):
    return conn.execute('''SELECT identificador AS unidade, to_char(competencia,'YYYY-MM') AS competencia,
        num_sessoes, kwh_total FROM v_consumo_mensal_unidade WHERE competencia=%s
        ORDER BY identificador''', (month(competencia),)).fetchall()


@app.get('/sessoes/em-revisao', response_model=list[Alert])
def alerts(conn=Depends(get_db, scope='function')):
    return conn.execute('SELECT * FROM v_sessoes_em_revisao ORDER BY inicio, id').fetchall()


@app.post('/sessoes/{id}/decisao')
def decide(id: int, body: Decision, conn=Depends(get_db, scope='function')):
    conn.execute('SELECT pg_advisory_xact_lock(260901)')
    session = conn.execute('SELECT * FROM sessao WHERE id=%s FOR UPDATE', (id,)).fetchone()
    if session is None:
        raise HTTPException(404, 'Sessão não encontrada')
    if session['status_revisao'] != 'em_revisao':
        raise HTTPException(409, 'Sessão não está em revisão')
    result = conn.execute('UPDATE sessao SET status_revisao=%s WHERE id=%s RETURNING *',
                         (body.decisao, id)).fetchone()
    conn.execute('''UPDATE fatura SET status='aberta' WHERE unidade_id=(SELECT unidade_id FROM usuario WHERE id=%s)
        AND competencia=date_trunc('month', %s::timestamptz)::date AND status <> 'paga' ''',
        (session['usuario_id'], session['inicio']))
    return result


def read_invoices(conn, competencia):
    return conn.execute('''SELECT un.identificador AS unidade, to_char(f.competencia,'YYYY-MM') AS competencia,
        f.num_sessoes, f.kwh_total, f.valor_variavel, f.valor_fixo, f.valor_total, f.status
        FROM fatura f JOIN unidade un ON un.id=f.unidade_id WHERE f.competencia=%s
        ORDER BY un.identificador''', (competencia,)).fetchall()


@app.get('/faturas', response_model=list[Invoice])
def invoices(competencia: str, conn=Depends(get_db, scope='function')):
    return read_invoices(conn, month(competencia))


@app.post('/faturas/gerar', response_model=list[Invoice])
def generate_invoices(competencia: str, conn=Depends(get_db, scope='function')):
    parsed = month(competencia)
    generate(conn, parsed)
    return read_invoices(conn, parsed)


@app.get('/previsao')
def forecast():
    if not PREVISAO.exists():
        raise HTTPException(503, 'Previsão ainda não gerada (falta IA/previsao.json)')
    return json.loads(PREVISAO.read_text(encoding='utf-8'))


@app.post('/simulador/sessoes', status_code=201)
def simulation(body: Simulation, conn=Depends(get_db, scope='function')):
    try:
        return simulate(conn, body.usuario_id, body.carregador_id, body.inicio,
                        body.energia_kwh, body.duracao_minutos)
    except ValueError as exc:
        raise HTTPException(409, str(exc)) from exc
