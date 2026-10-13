# Executar a API com Docker

Na raiz do repositório, com o Docker em execução:

1. Inicie o PostgreSQL e a API:

   ```bash
   docker compose -f backend/compose.yaml up --build -d
   ```

2. Confira se `db` está `healthy` e `api` está `Up`:

   ```bash
   docker compose -f backend/compose.yaml ps
   ```

3. Acesse a documentação interativa em [http://127.0.0.1:8001/docs](http://127.0.0.1:8001/docs). A API usa `http://127.0.0.1:8001` como endereço base; por exemplo, [http://127.0.0.1:8001/consumo-mensal?competencia=2026-09](http://127.0.0.1:8001/consumo-mensal?competencia=2026-09).

## Requisições de exemplo

No PowerShell, use `curl.exe`:

```powershell
curl.exe "http://127.0.0.1:8001/consumo-mensal?competencia=2026-09"
curl.exe "http://127.0.0.1:8001/sessoes/em-revisao"
curl.exe "http://127.0.0.1:8001/faturas?competencia=2026-09"
curl.exe "http://127.0.0.1:8001/previsao"
```

As requisições abaixo gravam no banco do Compose. No PowerShell, use `Invoke-RestMethod` para testar a geração de faturas, a decisão da sessão em revisão presente no `db/seed.sql` e o simulador:

```powershell
Invoke-RestMethod -Method Post -Uri "http://127.0.0.1:8001/faturas/gerar?competencia=2026-09"
Invoke-RestMethod -Method Post -Uri "http://127.0.0.1:8001/sessoes/5/decisao" -ContentType "application/json" -Body '{"decisao":"aprovada"}'
Invoke-RestMethod -Method Post -Uri "http://127.0.0.1:8001/simulador/sessoes" -ContentType "application/json" -Body '{"usuario_id":1,"carregador_id":1,"inicio":"2026-10-01T08:00:00-03:00","energia_kwh":10,"duracao_minutos":120}'
```

No Git Bash, os mesmos testes usam `curl`:

```bash
curl -X POST "http://127.0.0.1:8001/faturas/gerar?competencia=2026-09"
curl -X POST "http://127.0.0.1:8001/sessoes/5/decisao" -H "Content-Type: application/json" -d '{"decisao":"aprovada"}'
curl -X POST "http://127.0.0.1:8001/simulador/sessoes" -H "Content-Type: application/json" -d '{"usuario_id":1,"carregador_id":1,"inicio":"2026-10-01T08:00:00-03:00","energia_kwh":10,"duracao_minutos":120}'
```

O exemplo de decisão só funciona uma vez por sessão em revisão; uma segunda decisão para a mesma sessão retorna `409`. O simulador também pode retornar `409` se o carregador estiver ocupado no intervalo escolhido.

Para consultar os logs:

```bash
docker compose -f backend/compose.yaml logs --tail=100 api db
```

Para parar os contêineres:

```bash
docker compose -f backend/compose.yaml down
```
