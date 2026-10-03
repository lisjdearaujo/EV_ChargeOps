import { useEffect, useState } from "react";
import { buscarPrevisao } from "../api";

// "2026-10-04" -> "04/10" (sem usar Date, para evitar problema de fuso)
function dia(data) {
  const [, mes, d] = data.split("-");
  return `${d}/${mes}`;
}

export default function Previsao() {
  const [previsao, setPrevisao] = useState(null);

  useEffect(() => {
    buscarPrevisao().then(setPrevisao);
  }, []);

  if (!previsao) return <p>Carregando previsão...</p>;

  const maior = Math.max(...previsao.serie.map((p) => p.kwh));

  return (
    <section className="cartao">
      <h2>Previsão de consumo</h2>
      <p className="resumo">
        Estimativa diária feita pelo módulo de IA, para apoiar a negociação da
        demanda contratada com a distribuidora.
      </p>

      <div className="cartoes-resumo">
        <div className="metrica">
          <span>Modelo</span>
          <strong>{previsao.modelo}</strong>
        </div>
        <div className="metrica">
          <span>Erro médio (MAE)</span>
          <strong>{previsao.mae_kwh.toFixed(1)} kWh/dia</strong>
        </div>
        <div className="metrica">
          <span>Pico previsto</span>
          <strong>{previsao.pico_previsto_kw.toFixed(1)} kW</strong>
        </div>
        <div className="metrica">
          <span>Demanda recomendada</span>
          <strong>{previsao.demanda_recomendada_kw.toFixed(1)} kW</strong>
        </div>
      </div>

      <div className="grafico">
        {previsao.serie.map((p) => (
          <div className="coluna" key={p.data} title={`${dia(p.data)}: ${p.kwh} kWh`}>
            <div className="coluna-area">
              <div
                className={`coluna-barra coluna-${p.tipo}`}
                style={{ height: `${(p.kwh / maior) * 100}%` }}
              />
            </div>
            <span className="coluna-rotulo">{dia(p.data)}</span>
          </div>
        ))}
      </div>

      <p className="legenda">
        <span className="legenda-real" /> Real
        <span className="legenda-previsto" /> Previsto
      </p>
    </section>
  );
}