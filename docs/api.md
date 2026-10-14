# Documentação da API do EV ChargeOps

Formato: JSON. Datas em ISO 8601. Valores monetários em reais (número).
Endereço base local: `http://127.0.0.1:8001`. Documentação interativa em `/docs`.

## GET /consumo-mensal?competencia=2026-09
Consumo por unidade no mês (vem da view v_consumo_mensal_unidade).

```json
[
  { "unidade": "Bloco A - 101", "competencia": "2026-09", "num_sessoes": 2, "kwh_total": 31.5 },
  { "unidade": "Bloco A - 202", "competencia": "2026-09", "num_sessoes": 3, "kwh_total": 130.5 }
]
```

## GET /sessoes/em-revisao
Sessões sinalizadas pela IA aguardando decisão (view v_sessoes_em_revisao).

```json
[
  {
    "id": 5,
    "usuario": "Carlos Lima",
    "unidade": "Bloco A - 202",
    "inicio": "2026-09-20T19:00:00-03:00",
    "fim": "2026-09-21T06:00:00-03:00",
    "energia_kwh": 90.0,
    "anomaly_score": 0.87,
    "motivo_alerta": "Consumo de 90 kWh excede a capacidade da bateria declarada (48 kWh)"
  }
]
```

## POST /sessoes/{id}/decisao
O gestor resolve um alerta.

Corpo: `{ "decisao": "aprovada" }` ou `{ "decisao": "estornada" }`
Resposta 200: a sessão atualizada. Resposta 404 se a sessão não existir e 409 se não estiver em revisão.
Depois da decisão, a fatura da unidade volta a `aberta` para ser recalculada.

## GET /faturas?competencia=2026-09
Faturas por unidade (tabela fatura). Lista vazia se o rateio ainda não rodou.

```json
[
  {
    "unidade": "Bloco A - 101",
    "competencia": "2026-09",
    "num_sessoes": 2,
    "kwh_total": 31.5,
    "valor_variavel": 29.93,
    "valor_fixo": 40.0,
    "valor_total": 69.93,
    "status": "fechada"
  }
]
```

## POST /faturas/gerar?competencia=2026-09
Executa o rateio do mês e devolve as faturas geradas (mesmo formato do GET /faturas).
Uma fatura só fica `fechada` quando a unidade não tem sessões em revisão ou em andamento;
caso contrário fica `aberta`. Sessões estornadas não entram no cálculo.
Resposta 404 se não houver tarifa cadastrada para a competência.

## POST /simulador/sessoes
Cria uma sessão simulada (com leituras por minuto) e executa o módulo de IA sobre ela.

Corpo:
```json
{
  "usuario_id": 1,
  "carregador_id": 1,
  "inicio": "2026-10-01T08:00:00-03:00",
  "energia_kwh": 10,
  "duracao_minutos": 120
}
```
Resposta 201: a sessão criada, com `anomaly_score`, `status_revisao` e `motivo_alerta` preenchidos pela IA.
Resposta 409 se o usuário não estiver ativo com RFID, se o carregador estiver ocupado no intervalo
ou se a competência já estiver paga para a unidade.

## GET /previsao
Previsão de consumo diário para o painel do gestor (módulo de IA). O conteúdo vem do arquivo
`IA/previsao.json`, exportado pelo notebook `demand_forecast.ipynb`. Resposta 503 se o arquivo não existir.

```json
{
  "modelo": "XGBoost",
  "mae_kwh": 33.48,
  "serie": [
    { "data": "2015-10-04", "kwh": 6.55, "tipo": "real" },
    { "data": "2015-10-05", "kwh": 153.25, "tipo": "previsto" }
  ]
}
```
`modelo` é o algoritmo vencedor da comparação, `mae_kwh` o erro médio por dia em kWh e `serie`
mistura os últimos dias reais e os dias previstos (`tipo`). As datas são de 2015 porque o dataset
público usado no treino é desse ano.
