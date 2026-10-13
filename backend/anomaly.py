from functools import lru_cache
from pathlib import Path

import joblib
import pandas as pd

MODEL_PATH = Path(__file__).resolve().parents[1] / 'IA/modelos/isolation_forest.joblib'


@lru_cache(maxsize=1)
def load_model():
    model = joblib.load(MODEL_PATH)
    if list(model.feature_names_in_) != ['kwhtotal', 'chargetimehrs', 'starttime']:
        raise ValueError('Features do modelo incompatíveis com o notebook')
    return model


def detect(energy, hours, start_hour, capacity=None, historical_mean=None):
    model = load_model()
    features = pd.DataFrame([[float(energy), float(hours), start_hour]],
                            columns=['kwhtotal', 'chargetimehrs', 'starttime'])
    reasons = []
    if model.predict(features)[0] == -1:
        reasons.append('Padrão atípico (Isolation Forest)')
    if capacity is not None and energy > capacity:
        reasons.append(f'Consumo de {energy} kWh excede bateria de {capacity} kWh')
    if historical_mean is not None and energy > 2 * historical_mean:
        reasons.append('Consumo acima do dobro da média do usuário')
    # score_samples é negativo: inverter produz índice maior para mais anomalia.
    score = round(max(0.0, min(1.0, -float(model.score_samples(features)[0]))), 4)
    return score, 'em_revisao' if reasons else 'normal', '; '.join(reasons)[:200] or None
