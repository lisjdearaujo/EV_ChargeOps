# Evidências de funcionamento

Capturas de tela do protótipo rodando com Docker (API e banco) e o painel em React, seguindo o fluxo completo: dados de exemplo, alerta da IA, decisão do gestor, geração da fatura e previsão de consumo.

## 1. API no ar
Documentação interativa da API FastAPI, com todos os endpoints do protótipo.

<img width="1911" height="993" alt="image" src="https://github.com/user-attachments/assets/e5eec7fb-b44b-4f26-8527-69ce535b0985" />


## 2. Visão geral
Consumo do mês por unidade (162,0 kWh no total) e uma sessão aguardando revisão.

<img width="1913" height="983" alt="image" src="https://github.com/user-attachments/assets/59bd5cd3-8910-4338-afa8-dd8b76340939" />

## 3. Alerta da IA
Sessão de 90 kWh sinalizada pelo módulo de anomalias, com o motivo do alerta (consumo acima da capacidade da bateria declarada).

<img width="1907" height="985" alt="image" src="https://github.com/user-attachments/assets/9e05a222-68d5-41d9-85f8-8f42f8ac7148" />

## 4. Decisão do gestor
Depois de aprovar a sessão, o alerta sai da lista. A fatura da unidade, que estava aberta, pode ser fechada.

<img width="1912" height="984" alt="image" src="https://github.com/user-attachments/assets/21382739-df94-4303-9f27-42515fabcf06" />

## 5. Faturas geradas
Rateio do mês: R$ 69,93 para a unidade 101 e R$ 215,92 para a unidade 202, com a parcela variável e a parcela do custo fixo.

<img width="1917" height="982" alt="image" src="https://github.com/user-attachments/assets/c88dfc61-b360-480b-b66b-b7dfc5a34e08" />

## 6. Previsão de consumo
Gráfico com os últimos dias reais e os dias previstos pelo modelo vencedor (XGBoost, MAE 33,48 kWh/dia).

<img width="1914" height="977" alt="image" src="https://github.com/user-attachments/assets/f47f95c2-b2bd-4484-9490-df4dbc25e11f" />

## Notebooks com saídas executadas
- [`IA/anomaly_detection.ipynb`](../IA/anomaly_detection.ipynb): treino e teste do Isolation Forest.
- [`IA/demand_forecast.ipynb`](../IA/demand_forecast.ipynb): comparação entre baseline, ARIMA, Prophet e XGBoost.
