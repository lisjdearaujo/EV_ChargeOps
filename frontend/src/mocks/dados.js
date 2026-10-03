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

// Faturas de exemplo (valores ilustrativos; os reais virao do motor de rateio).
// A unidade 202 segue "aberta" porque tem uma sessao em revisao pela IA.
export const faturas = [
  {
    unidade: "Bloco A - 101",
    competencia: "2026-09",
    num_sessoes: 2,
    kwh_total: 31.5,
    valor_variavel: 29.93,
    valor_fixo: 40.0,
    valor_total: 69.93,
    status: "fechada",
  },
  {
    unidade: "Bloco A - 202",
    competencia: "2026-09",
    num_sessoes: 3,
    kwh_total: 130.5,
    valor_variavel: 0.0,
    valor_fixo: 0.0,
    valor_total: 0.0,
    status: "aberta",
  },
];