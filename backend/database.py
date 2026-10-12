import os

import psycopg
from psycopg.rows import dict_row


def connect():
    conn = psycopg.connect(
        os.getenv('DATABASE_URL', 'postgresql://postgres:postgres@localhost:5432/evchargeops'),
        row_factory=dict_row, connect_timeout=5,
    )
    conn.execute("SET TIME ZONE 'America/Sao_Paulo'")
    return conn


def get_db():
    with connect() as conn:
        yield conn
