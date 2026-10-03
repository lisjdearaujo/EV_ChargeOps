import { useEffect, useState } from "react";
import { buscarConsumoMensal, buscarFaturas, buscarSessoesEmRevisao } from "../api";

export default function Resumo({ competencia, versao }) {
  const [dados, setDados] = useState(null);

  // "versao" muda quando o gestor decide um alerta, para recontar
  useEffect(() => {
    Promise.all([
      buscarConsumoMensal(competencia),
      buscarFaturas(competencia),
      buscarSessoesEmRevisao(),
    ]).then(([consumo, faturas, alertas]) => {
      setDados({
        kwh: consumo.reduce((s, c) => s + c.kwh_total, 0),
        sessoes: consumo.reduce((s, c) => s + c.num_sessoes, 0),
        faturado: faturas.reduce((s, f) => s + f.valor_total, 0),
        alertas: alertas.length,
      });
    });
  }, [competencia, versao]);

  if (!dados) return null;

  return (
    <div className="kpis">
      <div className="kpi"><span>Consumo do mês</span><strong>{dados.kwh.toFixed(1)} kWh</strong></div>
      <div className="kpi"><span>Sessões</span><strong>{dados.sessoes}</strong></div>
      <div className="kpi">
        <span>Faturado</span>
        <strong>{dados.faturado.toLocaleString("pt-BR", { style: "currency", currency: "BRL" })}</strong>
      </div>
      <div className={`kpi ${dados.alertas > 0 ? "atencao" : ""}`}>
        <span>Alertas da IA pendentes</span><strong>{dados.alertas}</strong>
      </div>
    </div>
  );
}