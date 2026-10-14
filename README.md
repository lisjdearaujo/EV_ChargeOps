# Painel do gestor (front-end)

Painel em React com Vite: visão geral, alertas da IA, faturas e previsão de consumo.

## Como executar

1. Instale o Node.js (versão LTS recente).
2. Suba a API (ver `backend/README.md`) e confira o endereço em `src/api.js` (`API_URL`, padrão `http://localhost:8001`).
3. Na pasta `frontend`:

```bash
npm install
npm run dev
```

O painel abre em `http://localhost:5173`. Abra por esse endereço, pois a API só libera o CORS para ele.

Para usar dados de exemplo sem a API, mude `USAR_MOCK` para `true` em `src/api.js`.
