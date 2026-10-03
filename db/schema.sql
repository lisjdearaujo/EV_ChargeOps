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
-- Usuario: morador ou gestor. Acesso ativo (RFID cadastrado) define se paga o custo fixo
CREATE TABLE usuario (
    id                     SERIAL PRIMARY KEY,
    unidade_id             INTEGER      REFERENCES unidade(id),
    nome                   VARCHAR(120) NOT NULL,
    email                  VARCHAR(160) NOT NULL UNIQUE,
    perfil                 VARCHAR(10)  NOT NULL DEFAULT 'morador'
                           CHECK (perfil IN ('morador', 'gestor')),
    rfid_tag               VARCHAR(40)  UNIQUE,
    acesso_ativo           BOOLEAN      NOT NULL DEFAULT TRUE,
    veiculo_modelo         VARCHAR(80),
    capacidade_bateria_kwh NUMERIC(6,2),          -- usada pela IA para validar consumo
    criado_em              TIMESTAMPTZ  NOT NULL DEFAULT now()
);