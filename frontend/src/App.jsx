import ConsumoPorUnidade from "./components/ConsumoPorUnidade";
import AlertasIA from "./components/AlertasIA";
import "./App.css";

const COMPETENCIA = "2026-09";

export default function App() {
  return (
    <main className="painel">
      <header>
        <h1>EV ChargeOps</h1>
        <p>Painel do gestor · Setembro de 2026</p>
      </header>
      <AlertasIA />
      <ConsumoPorUnidade competencia={COMPETENCIA} />
    </main>
  );
}