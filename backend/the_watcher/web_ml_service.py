import os
import pickle
import threading
from django.conf import settings

class WebMLService:

    _instance = None
    _model = None
    _lock = threading.Lock()

    def __new__(cls):
        if cls._instance is None:
            cls._instance = super(WebMLService, cls).__new__(cls)
        return cls._instance

    def load_model(self):

        if self._model is None:

            with self._lock:

                if self._model is None:

                    model_path = os.path.join(
                        settings.BASE_DIR,
                        "..",
                        "models",
                        "Web_Model",
                        "webAnalysisModel.pkl"
                    )

                    with open(model_path, "rb") as f:
                        self._model = pickle.load(f)

                    print("WEB MODEL LOADED")

        return self._model

    def predict(self, url):

        model = self.load_model()

        prediction = model.predict([url])[0]

        return prediction


web_ml_service = WebMLService()