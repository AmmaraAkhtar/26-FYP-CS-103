import os
import pickle
import threading
import __main__
import pandas as pd
from django.conf import settings
from sklearn.base import BaseEstimator, TransformerMixin


bad_words = [
    'porn','xxx','sex','adult','nude','naked','boobs','breast','escort',
    'cam','cams','webcam','livecam','onlyfans','xvideo','xnxx','redtube',
    'hentai','bdsm','fetish','milf','teen','erotic','strip','stripchat',
    'casino','bet','betting','poker','slot','jackpot','roulette',
    'blackjack','win','winnings','bonus','freebet','odds','gamble',
    'free','offer','click','login','signup','verify','account',
    'secure','update','bonus','gift','promo','cheap','deal',
    's3x','p0rn','pr0n','xxx','xnx','sexx','pron','sexyy'
]


class URLFeatureExtractor(BaseEstimator, TransformerMixin):

    def fit(self, X, y=None):
        return self

    def transform(self, X):

        X = pd.DataFrame(X).copy()

        X['url'] = X['url'].astype(str).str.lower()

        X['url_length'] = X['url'].str.len()
        X['dot_count'] = X['url'].str.count(r'\.')
        X['dash_count'] = X['url'].str.count('-')
        X['slash_count'] = X['url'].str.count('/')
        X['at_count'] = X['url'].str.count('@')

        digit_count = X['url'].str.replace(
            r'\D', '', regex=True
        ).str.len()

        length = X['url'].str.len().replace(0, 1)

        X['digit_ratio'] = digit_count / length

        X['has_ip'] = X['url'].str.contains(
            r'\d+\.\d+\.\d+\.\d+'
        ).astype(int)

        X['has_https'] = X['url'].str.startswith(
            'https'
        ).astype(int)

        def check_bad_words(url):
            for word in bad_words:
                if word in url:
                    return 1
            return 0

        X['has_bad_word'] = X['url'].apply(check_bad_words)

        def clean_url(url):

            url = str(url).lower()

            url = url.replace('http://', '')
            url = url.replace('https://', '')
            url = url.replace('www.', '')

            url = url.split('#')[0]

            url = url.replace('/', '')

            return url

        X['url'] = X['url'].apply(clean_url)

        return X



__main__.URLFeatureExtractor = URLFeatureExtractor


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
                        "WebAnalysis",
                        "webAnalysisModel.pkl"
                    )

                    with open(model_path, "rb") as f:
                        self._model = pickle.load(f)

                    print("WEB MODEL LOADED")

        return self._model

    def predict(self, url):

        model = self.load_model()

        df = pd.DataFrame({
            'url': [url]
        })

        prediction = model.predict(df)[0]

        return prediction


web_ml_service = WebMLService()