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