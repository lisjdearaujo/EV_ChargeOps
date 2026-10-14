# EV ChargeOps — Enterprise Challenge 2026

**Parceiro:** GoodWe / FIAP Energy Innovation Lab

Plataforma de gestão e rateio de recargas de veículos elétricos em infraestruturas compartilhadas (condomínios, edifícios corporativos e campus), com IA para detecção de anomalias e previsão de consumo. O carregador de referência é o GoodWe HCA G2 (GW7K-HCA-20, 7 kW), instalado no estacionamento L1 da FIAP.

## Equipe

| Nome | RM |
|------|----|
| Eduardo Alves da Silva | RM 568601 |
| Gabrielly Drosda da Silva | RM 571793 |
| Lisandra Jacinto de Araujo | RM 574055 |

## Sprint 01 (resumo)

A Sprint 01 definiu o problema, a base regulatória e a arquitetura da solução. O texto completo, com fontes, está em [`docs/sprint1.md`](docs/sprint1.md).

- **Problema:** recarga compartilhada sem medição individual gera rateio impreciso e conflito. O condomínio não pode lucrar com a recarga, então a transparência é obrigatória.
- **Base regulatória:** Resolução Normativa ANEEL nº 1.000/2021. O art. 552 exige protocolos abertos (como o OCPP) em equipamentos de uso não exclusivamente privado.
- **Arquitetura em quatro camadas:** física (carregador), conectividade (Modbus TCP e OCPP), aplicação (CSMS, ingestão, rateio e IA) e apresentação (painel do gestor e app do usuário).
- **Rateio:** `fatura da unidade = soma(kWh da sessão × tarifa ajustada) + custo fixo mensal ÷ usuários ativos`, onde tarifa ajustada = tarifa base + fator de demanda (uso entre 18h e 21h) × adicional de ponta.
- **IA:** previsão de demanda (ARIMA, Prophet e XGBoost) e detecção de anomalias (Isolation Forest + regras determinísticas).

![Arquitetura do EV ChargeOps](https://github.com/user-attachments/assets/60e15c27-2470-45ed-8b62-5ae5f033dd27)

## Sprint 02 

Protótipo funcional: banco de dados, API com rateio e simulador, módulos de IA e painel do gestor.

#### Como executar

#### O que instalar antes (uma vez só)

1. **Docker Desktop**: https://www.docker.com/products/docker-desktop (depois de instalar, abra o programa e espere ele indicar que está rodando).
2. **Node.js (versão LTS)**: https://nodejs.org
3. **Git**: https://git-scm.com (se ainda não tiver).

#### Passo 1: baixar o projeto

Abra um terminal (no VS Code: menu **Terminal → New Terminal**) e rode:

```bash
git clone https://github.com/lisjdearaujo/EV_ChargeOps.git
cd EV_ChargeOps
```

#### Passo 2: ligar o banco de dados e a API

Com o Docker Desktop aberto, na pasta do projeto, rode:

```bash
docker compose -f backend/compose.yaml up --build -d
```

A primeira vez demora alguns minutos, pois baixa e monta tudo. Para conferir se funcionou, abra no navegador:

http://127.0.0.1:8001/docs

Se aparecer a página "EV ChargeOps" com a lista de endpoints, a API está no ar.

#### Passo 3: ligar o painel

Abra um **segundo terminal** (o primeiro pode ficar como está) e rode:

```bash
cd frontend
npm install
npm run dev
```

O `npm install` só precisa ser feito na primeira vez. Quando aparecer um endereço como `http://localhost:5173`, abra-o no navegador. É o painel do gestor.

#### Como usar o painel

1. **Visão geral:** mostra o consumo por unidade (162,0 kWh no total) e 1 alerta da IA.
2. **Alertas:** mostra a sessão suspeita. Clique em **Aprovar** ou **Estornar**.
3. **Faturas:** clique em gerar as faturas de 2026-09. Os valores esperados são R$ 69,93 (unidade 101) e R$ 215,92 (unidade 202).
4. **Previsão:** mostra o gráfico de consumo previsto pelo XGBoost.

#### Se algo der errado

- **Painel em branco ou sem dados:** confirme que a API está no ar (passo 2) e abra o painel por `http://localhost:5173`.
- **Erro no Docker:** confirme que o Docker Desktop está aberto e rodando.
- **Ver o que a API está fazendo:** `docker compose -f backend/compose.yaml logs --tail=100 api`

#### Para desligar

No terminal do painel, aperte `Ctrl + C`. Para parar a API e o banco:

```bash
docker compose -f backend/compose.yaml down
```

Mais detalhes em `backend/README.md`, `frontend/README.md` e `docs/api.md`.

### Evidências de funcionamento

Capturas de tela do fluxo completo em [`docs/evidencias.md`](docs/evidencias.md) (as imagens ficam em `docs/evidencias/`). Os notebooks da pasta `IA/` estão com as saídas executadas.

### Estrutura do repositório

| Pasta | Conteúdo |
|---|---|
| `db/` | Esquema PostgreSQL (`schema.sql`) e dados de exemplo (`seed.sql`) |
| `backend/` | API FastAPI: rateio, simulador, anomalias e previsão |
| `frontend/` | Painel do gestor em React + Vite |
| `IA/` | Notebooks, modelos treinados e `previsao.json` |
| `docs/` | Sprint 01, documentação da API e evidências (`docs/evidencias/`) |

### Banco de dados

PostgreSQL com tabelas de usuário, unidade, carregador, tarifa, sessão, leitura e fatura, além de views usadas pelo painel (`v_consumo_mensal_unidade` e `v_sessoes_em_revisao`). O Docker Compose cria o banco e carrega `schema.sql` e `seed.sql` na primeira subida.

### Backend

- **Rateio (`billing.py`):** aplica a fórmula da Sprint 01. O kWh de ponta é calculado por sessão, no fuso de São Paulo, usando as leituras do medidor quando existem. O custo fixo é dividido em centavos entre os moradores com acesso ativo e RFID. Trata sessão interrompida (cobra até a interrupção), estorno manual pelo gestor, usuário sem carregamento (paga só o fixo) e unidade com dois veículos (soma tudo). A fatura fica aberta enquanto houver sessão em revisão.
- **Anomalias (`anomaly.py`):** Isolation Forest + regra do dobro da média do usuário + capacidade da bateria, executados ao fim de cada sessão simulada. Grava score, status e motivo do alerta.
- **Simulador (`simulator.py`):** cria sessões com leituras por minuto direto no banco e valida usuário ativo com RFID.
- **Previsão:** a rota `/previsao` entrega o conteúdo de `IA/previsao.json`.

### IA

- **Anomalias** (`IA/anomaly_detection.ipynb`): treina o Isolation Forest com energia, duração e horário da sessão e salva `IA/modelos/isolation_forest.joblib`.
- **Previsão de demanda** (`IA/demand_forecast.ipynb`): compara baseline, ARIMA, Prophet e XGBoost sobre o consumo diário em kWh, com os últimos 20% da série como teste. O XGBoost venceu (MAE 33,48 kWh/dia e RMSE 43,24, contra ARIMA 51,13, Prophet 56,34 e baseline 111,59) e seu resultado é exportado para `IA/previsao.json`.

### Painel do gestor

Visão geral do consumo por unidade, alertas da IA com decisão do gestor (aprovar ou estornar), geração e consulta de faturas e gráfico de previsão de consumo.

### Decisões técnicas

- **FastAPI com SQL direto (psycopg), sem ORM:** o `db/schema.sql` é a única definição do banco, e as consultas ficam visíveis e fáceis de explicar. As views `v_consumo_mensal_unidade` e `v_sessoes_em_revisao` concentram as consultas do painel.
- **Rateio em centavos:** o custo fixo é dividido em centavos inteiros entre os usuários ativos, para o total das faturas bater exatamente com o valor a ratear, sem sobra por arredondamento.
- **kWh de ponta por sessão:** a parcela em horário de ponta (18h às 21h, no fuso de São Paulo) é calculada a partir das leituras por minuto do medidor, e não por estimativa proporcional à duração.
- **Fatura aberta enquanto houver sessão em revisão:** é a ligação entre a IA e a cobrança. A fatura só fecha depois da decisão do gestor, e sessões estornadas saem do cálculo.
- **Anomalias com modelo e regras:** o Isolation Forest (não supervisionado, sem exemplos rotulados de fraude) é combinado com duas regras determinísticas (dobro da média do usuário e capacidade da bateria), que explicam o motivo do alerta em linguagem clara.
- **Previsão: comparação de quatro modelos:** baseline, ARIMA, Prophet e XGBoost foram avaliados com divisão temporal (80% treino, 20% teste) e escolhidos pelo menor RMSE.
- **Previsão servida por arquivo:** o notebook exporta o resultado para `IA/previsao.json`, e a API apenas o lê. Assim o backend não depende de Prophet e statsmodels, e a imagem Docker fica menor.
- **Docker Compose:** o banco e a API sobem com um comando, e o `schema.sql` e o `seed.sql` são carregados automaticamente.
- **Painel com modo de exemplo:** o `src/api.js` tem a opção `USAR_MOCK`, que permite desenvolver e demonstrar o painel sem a API.

### Desvios em relação à Sprint 01 e justificativas

- **OCPP/Modbus:** o simulador grava direto no banco, sem servidor CSMS que receba BootNotification, Authorize, StartTransaction e StopTransaction. Justificativa: o prazo da sprint foi priorizado para o rateio e a IA, que são o núcleo da solução, e o simulador permite testar todos os casos excepcionais sem depender do carregador físico. A validação de usuário ativo com RFID no simulador imita o Authorize, mas não é o protocolo. A ingestão OCPP fica como evolução.
- **Bandeira da ANEEL:** não é consultada automaticamente. A tarifa vem da tabela `tarifa`, cadastrada manualmente. Justificativa: a tarifa manual torna os cálculos reproduzíveis e testáveis. A consulta automática fica como evolução.
- **Sessões interrompidas:** o simulador só gera sessões concluídas. O caso excepcional está implementado no rateio e aparece nos dados de exemplo.
- **Dados da IA:** a detecção de anomalias usa energia, duração, horário, histórico do usuário e capacidade da bateria. Não usa a curva de potência dos MeterValues, os alarmes do equipamento nem identidades não cadastradas, porque o simulador não produz esses dados.
- **Previsão de demanda:** usa dia da semana, mês e feriados como variáveis, sem temperatura. O dataset é o público `station_data_dataverse.csv`, e não o do Kaggle citado na Sprint 01, por ser o que estava disponível para treino.
- **Painel:** não tem gráficos por período, exportação de relatórios nem aplicativo do usuário. A prioridade foi o fluxo completo (alerta, decisão e fatura), e os itens ficam como evolução.

### Limitações

Os modelos foram treinados com um dataset público de estações de recarga de 2015, de escala de campus (cerca de 150 kWh/dia), muito maior que um condomínio com um carregador de 7 kW. Por isso o modelo de anomalias pode marcar como atípicas sessões normais de 7 kW, e a previsão demonstra o método, não é uma estimativa real do condomínio. Os valores de rateio foram conferidos com os dados de exemplo (unidades 101 e 202).

### Declaração de uso de IA

O grupo utilizou ferramentas de IA generativa (Claude, da Anthropic) como apoio durante a Sprint 02, nas seguintes partes: revisão do código do backend (rateio, simulador e detecção de anomalias), ajustes no painel, exportação da previsão de demanda para `IA/previsao.json` e redação da documentação (README e `docs/api.md`). Os modelos de IA (Isolation Forest e a comparação entre ARIMA, Prophet e XGBoost) foram treinados e avaliados pelo grupo nos notebooks da pasta `IA/`.

O grupo revisou todo o material gerado com apoio de IA, testou o funcionamento do sistema e consegue explicar cada trecho do código.
