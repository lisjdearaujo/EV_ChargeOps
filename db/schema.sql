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

-- Sessao de recarga (um ciclo StartTransaction -> StopTransaction)
CREATE TABLE sessao (
    id                SERIAL PRIMARY KEY,
    transaction_id    INTEGER      UNIQUE,            -- id da transacao no OCPP
    usuario_id        INTEGER      NOT NULL REFERENCES usuario(id),
    carregador_id     INTEGER      NOT NULL REFERENCES carregador(id),
    inicio            TIMESTAMPTZ  NOT NULL,
    fim               TIMESTAMPTZ,
    meter_inicio_kwh  NUMERIC(10,3) NOT NULL,
    meter_fim_kwh     NUMERIC(10,3),
    -- consumo bruto = leitura final - leitura inicial (nulo enquanto em andamento)
    energia_kwh       NUMERIC(10,3)
                      GENERATED ALWAYS AS (meter_fim_kwh - meter_inicio_kwh) STORED,
    status            VARCHAR(15)  NOT NULL DEFAULT 'em_andamento'
                      CHECK (status IN ('em_andamento', 'concluida', 'interrompida')),
    motivo_termino    VARCHAR(60),
    -- campos preenchidos pelo modulo de IA ao encerrar a sessao
    anomaly_score     NUMERIC(6,4),
    status_revisao    VARCHAR(15)  NOT NULL DEFAULT 'pendente'
                      CHECK (status_revisao IN
                             ('pendente', 'normal', 'em_revisao', 'aprovada', 'estornada')),
    motivo_alerta     VARCHAR(200),
    CHECK (fim IS NULL OR fim >= inicio),
    CHECK (meter_fim_kwh IS NULL OR meter_fim_kwh >= meter_inicio_kwh)
);

CREATE INDEX idx_sessao_usuario_inicio ON sessao (usuario_id, inicio);
CREATE INDEX idx_sessao_inicio         ON sessao (inicio);
CREATE INDEX idx_sessao_revisao        ON sessao (status_revisao);

-- Leituras periodicas (MeterValues, ~60 s): serie temporal da sessao
CREATE TABLE meter_value (
    id                      BIGSERIAL PRIMARY KEY,
    sessao_id               INTEGER      NOT NULL REFERENCES sessao(id) ON DELETE CASCADE,
    momento                 TIMESTAMPTZ  NOT NULL,
    potencia_kw             NUMERIC(6,3),
    tensao_v                NUMERIC(6,2),
    corrente_a              NUMERIC(6,2),
    energia_acumulada_kwh   NUMERIC(10,3)
);

CREATE INDEX idx_meter_sessao_momento ON meter_value (sessao_id, momento);

-- Fatura mensal por unidade
CREATE TABLE fatura (
    id               SERIAL PRIMARY KEY,
    unidade_id       INTEGER      NOT NULL REFERENCES unidade(id),
    competencia      DATE         NOT NULL,
    num_sessoes      INTEGER      NOT NULL DEFAULT 0,
    kwh_total        NUMERIC(10,3) NOT NULL DEFAULT 0,
    valor_variavel   NUMERIC(10,2) NOT NULL DEFAULT 0,  -- soma(kWh x tarifa ajustada)
    valor_fixo       NUMERIC(10,2) NOT NULL DEFAULT 0,  -- custo fixo / usuarios ativos
    valor_total      NUMERIC(10,2) NOT NULL DEFAULT 0,
    status           VARCHAR(10)  NOT NULL DEFAULT 'aberta'
                     CHECK (status IN ('aberta', 'fechada', 'paga')),
    gerada_em        TIMESTAMPTZ  NOT NULL DEFAULT now(),
    UNIQUE (unidade_id, competencia)
);