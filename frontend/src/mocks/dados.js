// Dados de exemplo no mesmo formato descrito em docs/api.md.
// Espelham os dados do db/seed.sql (setembro/2026).

export const consumoMensal = [
  { unidade: "Bloco A - 101", competencia: "2026-09", num_sessoes: 2, kwh_total: 31.5 },
  { unidade: "Bloco A - 202", competencia: "2026-09", num_sessoes: 3, kwh_total: 130.5 },
];

export const sessoesEmRevisao = [
  {
    id: 5,
    usuario: "Carlos Lima",
    unidade: "Bloco A - 202",
    inicio: "2026-09-20T19:00:00-03:00",
    fim: "2026-09-21T06:00:00-03:00",
    energia_kwh: 90.0,
    anomaly_score: 0.87,
    motivo_alerta: "Consumo de 90 kWh excede a capacidade da bateria declarada (48 kWh)",
  },
];

// Vazio até o motor de rateio do backend existir (ver docs/api.md).
export const faturas = [];