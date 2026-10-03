import { useEffect, useState } from "react";
import { buscarFaturas } from "../api";

function moeda(valor) {
  return valor.toLocaleString("pt-BR", { style: "currency", currency: "BRL" });
}

export default function Faturas({ competencia }) {
  const [faturas, setFaturas] = useState([]);
  const [carregando, setCarregando] = useState(true);

  useEffect(() => {
    buscarFaturas(competencia).then((resultado) => {
      setFaturas(resultado);
      setCarregando(false);
    });
  }, [competencia]);

  if (carregando) return <p>Carregando faturas...</p>;

  return (
    <section className="cartao">
      <h2>Faturas do mês</h2>

      {faturas.length === 0 ? (
        <p>Nenhuma fatura gerada neste mês. O rateio ainda não rodou.</p>
      ) : (
        <table>
          <thead>
            <tr>
              <th>Unidade</th>
              <th>Sessões</th>
              <th>kWh</th>
              <th>Variável</th>
              <th>Fixo</th>
              <th>Total</th>
              <th>Status</th>
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
                <td>
                  <strong>{moeda(f.valor_total)}</strong>
                </td>
                <td>
                  <span className={`status status-${f.status}`}>{f.status}</span>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      )}
    </section>
  );
}