import { consumoMensal, sessoesEmRevisao, faturas, previsao } from "./mocks/dados";

// Enquanto o backend nao existe, usamos os dados de exemplo.
// Quando a API estiver pronta: mudar para false e ajustar API_URL.
const USAR_MOCK = true;
const API_URL = "http://localhost:8000";

// Copia da lista de alertas, para o mock reagir as decisoes do gestor.
let alertasMock = [...sessoesEmRevisao];

export async function buscarConsumoMensal(competencia) {
  if (USAR_MOCK) {
    return consumoMensal.filter((c) => c.competencia === competencia);
  }
  const resposta = await fetch(`${API_URL}/consumo-mensal?competencia=${competencia}`);
  return resposta.json();
}

export async function buscarSessoesEmRevisao() {
  if (USAR_MOCK) {
    return alertasMock;
  }
  const resposta = await fetch(`${API_URL}/sessoes/em-revisao`);
  return resposta.json();
}

export async function decidirSessao(id, decisao) {
  // decisao: "aprovada" ou "estornada"
  if (USAR_MOCK) {
    alertasMock = alertasMock.filter((s) => s.id !== id);
    return { id, status_revisao: decisao };
  }
  const resposta = await fetch(`${API_URL}/sessoes/${id}/decisao`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ decisao }),
  });
  return resposta.json();
}

export async function buscarFaturas(competencia) {
  if (USAR_MOCK) {
    return faturas.filter((f) => f.competencia === competencia);
  }
  const resposta = await fetch(`${API_URL}/faturas?competencia=${competencia}`);
  return resposta.json();
}

export async function buscarPrevisao() {
  if (USAR_MOCK) {
    return previsao;
  }
  const resposta = await fetch(`${API_URL}/previsao`);
  return resposta.json();
}