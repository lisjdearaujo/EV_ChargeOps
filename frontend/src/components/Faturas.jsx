import { useEffect, useState } from "react";
import { buscarFaturas, gerarFaturas } from "../api";

function moeda(valor) {
  return valor.toLocaleString("pt-BR", { style: "currency", currency: "BRL" });
}

export default function Faturas({ competencia }) {
  const [faturas, setFaturas] = useState([]);
  const [carregando, setCarregando] = useState(true);
  const [gerando, setGerando] = useState(false);

  useEffect(() => {
    buscarFaturas(competencia).then((resultado) => {
      setFaturas(resultado);
      setCarregando(false);
    });
  }, [competencia]);

  async function gerar() {
    setGerando(true);
    const resultado = await gerarFaturas(competencia);
    // Se a API devolver erro (ex.: tarifa não cadastrada), mantém a lista atual
    if (Array.isArray(resultado)) setFaturas(resultado);
    setGerando(false);
  }

  if (carregando) return <p>Carregando faturas...</p>;

  return (
    <section className="cartao">
      <h2>Faturas do mês</h2>
      <p className="resumo">
        O rateio calcula o consumo de cada unidade. Faturas com sessões em
        revisão ficam abertas até o gestor decidir.
      </p>
      <p>
        <button className="btn-aprovar" onClick={gerar} disabled={gerando}
          style={{ border: 0, borderRadius: 8, padding: "8px 16px", color: "#fff", cursor: "pointer" }}>
          {gerando ? "Gerando..." : "Gerar faturas do mês"}
        </button>
      </p>

      {faturas.length === 0 ? (
        <p>Nenhuma fatura gerada neste mês. O rateio ainda não rodou.</p>
      ) : (
        <table>
          <thead>
            <tr>
              <th>Unidade</th><th>Sessões</th><th>kWh</th><th>Variável</th>
              <th>Fixo</th><th>Total</th><th>Status</th>
            </tr>
          </thead>
          <tbody>
            {faturas.map((f) => (
              <tr key={f.unidade}>
                <td>{f.unidade}</td>
                <td>{f.num_sessoes}</td>
                <td>{f.kwh_total.toFixed(1)}</td>
                <td>{moeda(f.valor_variavel)}</td>
                <td>{moeda(f.valor_fixo)}</td>
                <td><strong>{moeda(f.valor_total)}</strong></td>
                <td><span className={`status status-${f.status}`}>{f.status}</span></td>
              </tr>
            ))}
          </tbody>
        </table>
      )}
    </section>
  );
}