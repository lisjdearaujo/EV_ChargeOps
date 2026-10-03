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

CREATE TABLE carregador (
    id                  SERIAL PRIMARY KEY,
    codigo              VARCHAR(40)  NOT NULL UNIQUE,  -- charge point id do OCPP
    modelo              VARCHAR(40)  NOT NULL,
    potencia_nominal_kw NUMERIC(5,2) NOT NULL,
    local               VARCHAR(80)
);

-- Tarifa vigente por competencia (mes). A bandeira ajusta o valor base do kWh
CREATE TABLE tarifa (
    id                  SERIAL PRIMARY KEY,
    competencia         DATE         NOT NULL UNIQUE
                        CHECK (competencia = date_trunc('month', competencia)::date),
    bandeira            VARCHAR(10)  NOT NULL
                        CHECK (bandeira IN ('verde', 'amarela', 'vermelha')),
    tarifa_base_kwh     NUMERIC(8,4) NOT NULL,   -- R$/kWh ja com bandeira aplicada
    adicional_ponta_kwh NUMERIC(8,4) NOT NULL,   -- R$/kWh somado no horario de ponta
    custo_fixo_mensal   NUMERIC(10,2) NOT NULL,  -- manutencao e depreciacao
    ponta_inicio        TIME         NOT NULL DEFAULT '18:00',
    ponta_fim           TIME         NOT NULL DEFAULT '21:00'
);