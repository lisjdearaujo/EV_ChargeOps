-- Dados de exemplo (setembro/2026). Valores ficticios para desenvolvimento.

INSERT INTO unidade (identificador, responsavel) VALUES
    ('Bloco A - 101', 'Maria Souza'),
    ('Bloco A - 202', 'Carlos Lima'),
    ('Bloco B - 303', 'Ana Ribeiro');

INSERT INTO usuario (unidade_id, nome, email, perfil, rfid_tag, acesso_ativo,
                     veiculo_modelo, capacidade_bateria_kwh) VALUES
    (1, 'Maria Souza',   'maria@exemplo.com',   'morador', 'RFID-0001', TRUE,  'BYD Dolphin',    44.9),
    (2, 'Carlos Lima',   'carlos@exemplo.com',  'morador', 'RFID-0002', TRUE,  'GWM Ora 03',     48.0),
    (2, 'Paula Lima',    'paula@exemplo.com',   'morador', 'RFID-0003', TRUE,  'Renault Zoe',    52.0),  -- 2o veiculo da unidade 2
    (3, 'Ana Ribeiro',   'ana@exemplo.com',     'morador', NULL,        FALSE, 'BYD Dolphin Mini', 38.0), -- acesso suspenso
    (NULL, 'Gestor Condominio', 'gestor@exemplo.com', 'gestor', NULL,   TRUE,  NULL, NULL);

INSERT INTO carregador (codigo, modelo, potencia_nominal_kw, local) VALUES
    ('GW7K-HCA-20-L1', 'GW7K-HCA-20', 7.00, 'Estacionamento L1');

INSERT INTO tarifa (competencia, bandeira, tarifa_base_kwh, adicional_ponta_kwh, custo_fixo_mensal) VALUES
    ('2026-09-01', 'amarela', 0.9500, 0.4000, 120.00),
    ('2026-10-01', 'verde',   0.9000, 0.4000, 120.00);

    -- Sessoes de setembro.
-- 1: fora da ponta | 2: dentro da ponta | 3: interrompida por falha
-- 4: unidade 2, segundo veiculo | 5: consumo anomalo, aguardando revisao
INSERT INTO sessao (transaction_id, usuario_id, carregador_id, inicio, fim,
                    meter_inicio_kwh, meter_fim_kwh, status, motivo_termino,
                    anomaly_score, status_revisao, motivo_alerta) VALUES
    (1001, 1, 1, '2026-09-03 22:00-03', '2026-09-04 02:00-03', 100.000, 128.000,
     'concluida',    'EVDisconnected', 0.0800, 'normal', NULL),
    (1002, 2, 1, '2026-09-05 18:30-03', '2026-09-05 20:30-03', 128.000, 141.500,
     'concluida',    'EVDisconnected', 0.1200, 'normal', NULL),
    (1003, 1, 1, '2026-09-10 08:00-03', '2026-09-10 08:40-03', 141.500, 145.000,
     'interrompida', 'EVSEFault',      0.3100, 'normal', NULL),
    (1004, 3, 1, '2026-09-12 23:00-03', '2026-09-13 03:00-03', 145.000, 172.000,
     'concluida',    'EVDisconnected', 0.0900, 'normal', NULL),
    (1005, 2, 1, '2026-09-20 19:00-03', '2026-09-21 06:00-03', 172.000, 262.000,
     'concluida',    'EVDisconnected', 0.8700, 'em_revisao',
     'Consumo de 90 kWh excede a capacidade da bateria declarada (48 kWh)');

-- Algumas leituras de exemplo para a sessao 1 (serie temporal)
INSERT INTO meter_value (sessao_id, momento, potencia_kw, tensao_v, corrente_a, energia_acumulada_kwh) VALUES
    (1, '2026-09-03 22:01-03', 6.90, 220.0, 31.4, 100.115),
    (1, '2026-09-03 22:02-03', 6.95, 220.0, 31.6, 100.231),
    (1, '2026-09-03 22:03-03', 6.95, 219.8, 31.6, 100.347);