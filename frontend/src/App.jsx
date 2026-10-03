import { useState } from "react";
import Resumo from "./components/Resumo";
import ConsumoPorUnidade from "./components/ConsumoPorUnidade";
import AlertasIA from "./components/AlertasIA";
import Faturas from "./components/Faturas";
import Previsao from "./components/Previsao";
import "./App.css";

const COMPETENCIA = "2026-09";

const ABAS = [
  { id: "geral", nome: "Visão geral" },
  { id: "alertas", nome: "Alertas da IA" },
  { id: "faturas", nome: "Faturas" },
  { id: "previsao", nome: "Previsão" },
];

export default function App() {
  const [aba, setAba] = useState("geral");
  const [versao, setVersao] = useState(0);
  const atual = ABAS.find((a) => a.id === aba);

  return (
    <div className="app">
      <aside className="lateral">
        <div className="marca">
          <strong>EV ChargeOps</strong>
          <span>Painel do gestor</span>
        </div>
        <nav className="menu">
          {ABAS.map((a) => (
            <button
              key={a.id}
              className={a.id === aba ? "ativo" : ""}
              onClick={() => setAba(a.id)}
            >
              {a.nome}
            </button>
          ))}
        </nav>
      </aside>

      <main className="conteudo">
        <header className="topo">
          <h1>{atual.nome}</h1>
          <p>Setembro de 2026</p>
        </header>

        {aba === "geral" && (
          <>
            <Resumo competencia={COMPETENCIA} versao={versao} />
            <ConsumoPorUnidade competencia={COMPETENCIA} />
          </>
        )}
        {aba === "alertas" && <AlertasIA aoDecidir={() => setVersao((v) => v + 1)} />}
        {aba === "faturas" && <Faturas competencia={COMPETENCIA} />}
        {aba === "previsao" && <Previsao />}
      </main>
    </div>
  );
}