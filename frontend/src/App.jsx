import ConsumoPorUnidade from "./components/ConsumoPorUnidade";
import "./App.css";

const COMPETENCIA = "2026-09";

export default function App() {
  return (
    <main className="painel">
      <header>
        <h1>EV ChargeOps</h1>
        <p>Painel do gestor · Setembro de 2026</p>
      </header>
      <ConsumoPorUnidade competencia={COMPETENCIA} />
    </main>
  );
}