import { useEffect, useState } from "react";
import { buscarSessoesEmRevisao, decidirSessao } from "../api";

function formatarData(iso) {
  return new Date(iso).toLocaleString("pt-BR", {
    day: "2-digit",
    month: "2-digit",
    hour: "2-digit",
    minute: "2-digit",
  });
}

export default function AlertasIA() {
  const [alertas, setAlertas] = useState([]);
  const [carregando, setCarregando] = useState(true);

  useEffect(() => {
    buscarSessoesEmRevisao().then((resultado) => {
      setAlertas(resultado);
      setCarregando(false);
    });
  }, []);

  async function decidir(id, decisao) {
    await decidirSessao(id, decisao);
    // Tira o alerta da tela depois que o gestor decidiu
    setAlertas((atuais) => atuais.filter((a) => a.id !== id));
  }

  if (carregando) return <p>Carregando alertas...</p>;

  return (
    <section className="cartao">
      <h2>Alertas da IA</h2>
      <p className="resumo">
        Sessões sinalizadas como suspeitas. A fatura da unidade só fecha depois
        que o gestor decidir.
      </p>

      {alertas.length === 0 && <p>Nenhuma sessão aguardando revisão.</p>}

      {alertas.map((a) => (
        <div className="alerta" key={a.id}>
          <div className="alerta-topo">
            <strong>{a.usuario}</strong> · {a.unidade}
            <span className="selo">score {a.anomaly_score.toFixed(2)}</span>
          </div>
          <p className="alerta-detalhe">
            {formatarData(a.inicio)} até {formatarData(a.fim)} ·{" "}
            {a.energia_kwh.toFixed(1)} kWh
          </p>
          <p className="alerta-motivo">{a.motivo_alerta}</p>
          <div className="acoes">
            <button className="btn-aprovar" onClick={() => decidir(a.id, "aprovada")}>
              Aprovar
            </button>
            <button className="btn-estornar" onClick={() => decidir(a.id, "estornada")}>
              Estornar
            </button>
          </div>
        </div>
      ))}
    </section>
  );
}