-- EV ChargeOps - esquema PostgreSQL
-- Entidades da Sprint 01: usuario, unidade, sessao, fatura
-- Apoio: carregador, meter_value (serie temporal), tarifa (config mensal)

DROP VIEW  IF EXISTS v_sessoes_em_revisao;
DROP VIEW  IF EXISTS v_consumo_mensal_unidade;
DROP TABLE IF EXISTS fatura        CASCADE;
DROP TABLE IF EXISTS meter_value   CASCADE;
DROP TABLE IF EXISTS sessao        CASCADE;
DROP TABLE IF EXISTS tarifa        CASCADE;
DROP TABLE IF EXISTS usuario       CASCADE;
DROP TABLE IF EXISTS carregador    CASCADE;
DROP TABLE IF EXISTS unidade       CASCADE;

-- Unidade condominial: responsavel unico pelo pagamento, mesmo com varios veiculos
CREATE TABLE unidade (
    id            SERIAL PRIMARY KEY,
    identificador VARCHAR(20)  NOT NULL UNIQUE,   -- ex.: 'Bloco A - 101'
    responsavel   VARCHAR(120) NOT NULL,
    ativa         BOOLEAN      NOT NULL DEFAULT TRUE
);
