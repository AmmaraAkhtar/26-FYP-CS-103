import re 
import pandas as pd
from django.conf import settings
import os
import pickle

## App NAme Preprocessing for ML Pipeline (Training + Prediction)
def preprocess_app_name(text):
    """
    Clean app names for ML pipeline (training + prediction)
    """
    if pd.isnull(text):
        return ""

    # 1. lowercase
    text = text.lower()

    # 2. remove special characters (keep letters, numbers, space)
    text = re.sub(r'[^a-z0-9 ]', ' ', text)

    # 3. remove digits (optional but recommended for app names)
    text = re.sub(r'\d+', ' ', text)

    # 4. remove extra spaces
    text = re.sub(r'\s+', ' ', text).strip()

    return text




MODEL_PATH = os.path.join(
    settings.BASE_DIR,
    "models/App_Analysis_Data/AppAnalysisModel.pkl"
)

with open(MODEL_PATH, "rb") as f:
    app_model = pickle.load(f)