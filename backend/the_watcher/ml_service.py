import os
import pickle
import threading
from django.conf import settings
import pandas as pd
import re
import __main__


# IMPORTANT:
# Same preprocessing function yahan define karo
# jo model training ke waqt use hui thi

def preprocess_app_name(app_name):
    if pd.isnull(app_name):
        return ""

    # 1. lowercase
    app_name = app_name.lower()

    # 2. remove special characters (keep letters, numbers, space)
    app_name = re.sub(r'[^a-z0-9 ]', ' ', app_name)

    # 3. remove digits (optional but recommended for app names)
    app_name = re.sub(r'\d+', ' ', app_name)

    # 4. remove extra spaces
    app_name = re.sub(r'\s+', ' ', app_name).strip()

    return app_name

__main__.preprocess_app_name = preprocess_app_name

class MLModelService:
    _instance = None
    _model = None
    _lock = threading.Lock()

    def __new__(cls):
        if cls._instance is None:
            cls._instance = super(MLModelService, cls).__new__(cls)
        return cls._instance

    def load_model(self):
        if self._model is None:
            with self._lock:

                if self._model is None:

                    model_path = os.path.normpath(
                        os.path.join(
                            settings.BASE_DIR,
                            "..",
                            "models",
                            "App_Analysis_Data",
                            "AppAnalysisModel.pkl"
                        )
                    )

                    print("MODEL PATH:", model_path)

                    if not os.path.exists(model_path):
                        raise FileNotFoundError(
                            f"Model not found: {model_path}"
                        )

                    with open(model_path, "rb") as f:
                        self._model = pickle.load(f)

                    print("MODEL LOADED SUCCESSFULLY")

        return self._model

    def predict(self, data):

        model = self.load_model()

        # agar single string aaye to list bana do
        if isinstance(data, str):
            data = [data]

        predictions = model.predict(data)

        return predictions


ml_service = MLModelService()