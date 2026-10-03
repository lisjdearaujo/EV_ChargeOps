# Documentação da API do EV ChargeOps

Formato: JSON. Datas em ISO 8601. Valores monetários em reais (número).

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
    "energia_kwh": 90.0,<img width="267" height="248" alt="image" src="https://github.com/user-attachments/assets/ceafe0d6-cef5-46a3-8774-f02276d68227" />

    "anomaly_score": 0.87,
    "motivo_alerta": "Consumo de 90 kWh excede a capacidade da bateria declarada (48 kWh)"
  }
]
```

## POST /sessoes/{id}/decisao
O gestor resolve um alerta.

Corpo: `{ "decisao": "aprovada" }` ou `{ "decisao": "estornada" }`
Resposta 200: a sessão atualizada. Resposta 409 se a sessão não estiver em revisão.

## GET /faturas?competencia=2026-09
Faturas por unidade (tabela fatura). Lista vazia se o rateio ainda não rodou.

```json
[
  {
    "unidade": "Bloco A - 101",
    "competencia": "2026-09",
    "num_sessoes": 2,
    "kwh_total": 31.5,
    "valor_variavel": 0.0,
    "valor_fixo": 0.0,
    "valor_total": 0.0,
    "status": "aberta"
  }
]
```
(valores acima são só ilustrativos do formato)

## GET /previsao
Previsão diária de consumo para o painel do gestor (módulo de IA).

```json
{
  "modelo": "Prophet",
  "mae_kwh": 1.8,
  "pico_previsto_kw": 6.9,
  "demanda_recomendada_kw": 7.0,
  "serie": [
    { "data": "2026-10-03", "kwh": 5.5, "tipo": "real" },
    { "data": "2026-10-04", "kwh": 5.8, "tipo": "previsto" }
  ]
}
```
`modelo` é o algoritmo vencedor da comparação, `mae_kwh` o erro médio por dia, e `serie` mistura os últimos dias reais e os dias previstos (`tipo`). Formato proposto pelo front, a confirmar com a pessoa da IA.
