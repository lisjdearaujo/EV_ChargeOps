import { useEffect, useState } from "react";
import { buscarConsumoMensal } from "../api";

export default function ConsumoPorUnidade({ competencia }) {
  const [dados, setDados] = useState([]);
  const [carregando, setCarregando] = useState(true);

  // busca os dados quando a tela abre (e se a competencia mudar)
  useEffect(() => {
    buscarConsumoMensal(competencia).then((resultado) => {
      setDados(resultado);
      setCarregando(false);
    });
  }, [competencia]);

  if (carregando) return <p>Carregando...</p>;
  if (dados.length === 0) return <p>Nenhum consumo registrado neste mês.</p>;

  const maior = Math.max(...dados.map((d) => d.kwh_total));
  const total = dados.reduce((soma, d) => soma + d.kwh_total, 0);

  return (
    <section className="cartao">
      <h2>Consumo por unidade</h2>
      <p className="resumo">
        Total do mês: <strong>{total.toFixed(1)} kWh</strong>
      </p>

      <table>
        <thead>
          <tr>
            <th>Unidade</th>
            <th>Sessões</th>
            <th>kWh</th>
          </tr>
        </thead>
        <tbody>
          {dados.map((d) => (
            <tr key={d.unidade}>
              <td>{d.unidade}</td>
              <td>{d.num_sessoes}</td>
              <td>{d.kwh_total.toFixed(1)}</td>
            </tr>
          ))}
        </tbody>
      </table>

      <div>
        {dados.map((d) => (
          <div className="barra-linha" key={d.unidade}>
            <span className="barra-nome">{d.unidade}</span>
            <div className="barra-fundo">
              <div
                className="barra"
                style={{ width: `${(d.kwh_total / maior) * 100}%` }}
              />
            </div>
          </div>
        ))}
      </div>
    </section>
  );
}