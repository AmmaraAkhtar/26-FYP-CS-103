import os
import pickle
from django.conf import settings


class MLModelService:
    _instance = None
    _model = None

    def __new__(cls):
        if cls._instance is None:
            cls._instance = super(MLModelService, cls).__new__(cls)
        return cls._instance

    def load_model(self):
        if self._model is None:
            model_path = os.path.join(
                settings.BASE_DIR,
                "models/App_Analysis_Data/AppAnalysisModel.pkl"
            )
            with open(model_path, "rb") as f:
                self._model = pickle.load(f)

        return self._model

    def predict(self, data):
        model = self.load_model()
        return model.predict(data)


# global single instance
ml_service = MLModelService()