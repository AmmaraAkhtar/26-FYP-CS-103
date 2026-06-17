# import os
# import pickle
# import threading
# from django.conf import settings
# import pandas as pd
# import re
# import __main__


# # IMPORTANT:
# # Same preprocessing function yahan define karo
# # jo model training ke waqt use hui thi

# def preprocess_app_name(app_name):
#     if pd.isnull(app_name):
#         return ""

#     # 1. lowercase
#     app_name = app_name.lower()

#     # 2. remove special characters (keep letters, numbers, space)
#     app_name = re.sub(r'[^a-z0-9 ]', ' ', app_name)

#     # 3. remove digits (optional but recommended for app names)
#     app_name = re.sub(r'\d+', ' ', app_name)

#     # 4. remove extra spaces
#     app_name = re.sub(r'\s+', ' ', app_name).strip()

#     return app_name

# __main__.preprocess_app_name = preprocess_app_name

# class MLModelService:
#     _instance = None
#     _model = None
#     _encoder = None
#     _lock = threading.Lock()

#     def __new__(cls):
#         if cls._instance is None:
#             cls._instance = super(MLModelService, cls).__new__(cls)
#         return cls._instance

#     def load_model(self):
#         if self._model is None:
#             with self._lock:

#                 if self._model is None:

#                     model_path = os.path.normpath(
#                         os.path.join(
#                             settings.BASE_DIR,
#                             "..",
#                             "models",
#                             "App_Analysis_Data",
#                             "AppAnalysisModel.pkl"
#                         )
#                     )

#                     print("MODEL PATH:", model_path)

#                     if not os.path.exists(model_path):
#                         raise FileNotFoundError(
#                             f"Model not found: {model_path}"
#                         )

#                     with open(model_path, "rb") as f:
#                         self._model = pickle.load(f)

#                     print("MODEL LOADED SUCCESSFULLY")

#         return self._model
#     def load_encoder(self):
#         if self._encoder is None:
#             encoder_path = os.path.join(settings.BASE_DIR, "..", "models","App_Analysis_Data", "app_label_encoder.pkl")
#             with open(encoder_path, "rb") as f:
#                 self._encoder = pickle.load(f)
#         return self._encoder

#     def predict(self, data):

#         model = self.load_model()
#         encoder = self.load_encoder()

#         # agar single string aaye to list bana do
#         if isinstance(data, str):
#             data = [data]

#         predictions = model.predict(data)

#         return encoder.inverse_transform(predictions)


# ml_service = MLModelService()















import os
import pickle
import threading
import numpy as np
import pandas as pd
import re
import __main__

from django.conf import settings


def preprocess_app_name(app_name):
    if pd.isnull(app_name):
        return ""

    # 1. lowercase
    app_name = app_name.lower()

    # 2. remove special characters (keep letters, numbers, space)
    app_name = re.sub(r'[^a-z0-9 ]', ' ', app_name)

    # 3. remove digits
    app_name = re.sub(r'\d+', ' ', app_name)

    # 4. remove extra spaces
    app_name = re.sub(r'\s+', ' ', app_name).strip()

    return app_name

__main__.preprocess_app_name = preprocess_app_name


class MLModelService:
    _instance = None
    _model = None
    _encoder = None
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
                            #"..",
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

    def load_encoder(self):
        if self._encoder is None:
            encoder_path = os.path.join(
                settings.BASE_DIR,
                #"..",
                "models",
                "App_Analysis_Data",
                "app_label_encoder.pkl"
            )
            with open(encoder_path, "rb") as f:
                self._encoder = pickle.load(f)
        return self._encoder

    def predict(self, data):
        """
        Original predict — returns class labels only.
        Backward compatible — existing code mein koi change nahi chahiye.
        """
        model = self.load_model()
        encoder = self.load_encoder()

        if isinstance(data, str):
            data = [data]

        predictions = model.predict(data)
        return encoder.inverse_transform(predictions)

    def predict_with_confidence_batch(self, app_names):
        """
        Batch prediction with per-class confidence scores.

        Returns:
            List of dicts:
            [
                {
                    "predicted_class": "Games",
                    "confidence": 0.87,
                    "all_probs": {"Education": 0.02, "Games": 0.87, ...}
                },
                ...
            ]

        Usage:
            results = ml_service.predict_with_confidence_batch(["pubg mobile", "chrome"])
            category   = results[0]["predicted_class"]   # "Games"
            confidence = results[0]["confidence"]        # 0.87
        """
        model = self.load_model()
        encoder = self.load_encoder()

        if isinstance(app_names, str):
            app_names = [app_names]

        # shape: (n_samples, n_classes)
        proba_matrix = model.predict_proba(app_names)
        classes = encoder.classes_  # ['Education', 'Entertainment', 'Games', ...]

        results = []
        for proba in proba_matrix:
            predicted_idx   = int(np.argmax(proba))
            predicted_class = classes[predicted_idx]
            confidence      = float(proba[predicted_idx])

            results.append({
                "predicted_class": predicted_class,
                "confidence":      round(confidence, 4),
                "all_probs": {
                    cls: round(float(p), 4)
                    for cls, p in zip(classes, proba)
                }
            })

        return results

    def predict_single_with_confidence(self, app_name):
        """
        Single app prediction with confidence.
        Convenience wrapper around predict_with_confidence_batch.

        Returns:
            {
                "predicted_class": "Social",
                "confidence": 0.91,
                "all_probs": {...}
            }
        """
        results = self.predict_with_confidence_batch([app_name])
        return results[0]


ml_service = MLModelService()