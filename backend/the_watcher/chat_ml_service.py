import string
import pickle
import threading
from django.conf import settings
import pandas as pd
import re
import __main__
import os


chat_words = {
    
    "u": "you",
    "ur": "your",
    "r": "are",
    "btw": "by the way",
    "idk": "i do not know",
    "imo": "in my opinion",
    "imho": "in my humble opinion",
    "lol": "laughing out loud",
    "lmao": "laughing my ass off",
    "rofl": "rolling on floor laughing",
    "omg": "oh my god",
    "omw": "on my way",
    "brb": "be right back",
    "bbl": "be back later",
    "ttyl": "talk to you later",
    "gtg": "got to go",
    "gr8": "great",
    "b4": "before",
    "2day": "today",
    "2moro": "tomorrow",
    "luv": "love",
    "k": "okay",
    "kk": "okay",
    "okie": "okay",
    "pls": "please",
    "plz": "please",
    "thx": "thanks",
    "ty": "thank you",
    "np": "no problem",
    "smh": "shaking my head",
    "tbh": "to be honest",
    "fomo": "fear of missing out",
    "bae": "before anyone else",
    "lit": "amazing",
    "salty": "angry or bitter",
    "sus": "suspicious",
    "dm": "direct message",
    "rn": "right now",
    "af": "as f***",
    "ikr": "i know right",
    "yolo": "you only live once",
    "ftw": "for the win",
    "idc": "i do not care",
    "wyd": "what are you doing",
    "wya": "where you at",
    "hbu": "how about you",
    "afaik": "as far as i know",
    "tldr": "too long didn't read",

    "fr": "for real",
    "ngl": "not gonna lie",
    "fs": "for sure",
    "dead": "very funny / shocked",
    "no cap": "no lie",
    "cap": "lie",
    "lowkey": "slightly",
    "highkey": "obviously",
    "vibes": "feelings / mood",
    "mood": "relatable feeling",
    "slay": "doing great",
    "fire": "excellent",
    "mid": "average / bad",
    "hits different": "feels unique",

   
    "cuz": "because",
    "coz": "because",
    "bc": "because",
    "bcz": "because",
    "pls": "please",
    "plz": "please",
    "msg": "message",
    "txt": "text",
    "grl": "girl",
    "boi": "boy",

   
    "gg": "good game",
    "wp": "well played",
    "noob": "beginner",
    "afk": "away from keyboard",
    "ppl": "people",
    "ez": "easy",
    "nerf": "weaken",
    "buff": "strengthen",

    "i cant": "i cannot",
    "cant take it": "cannot handle situation",
    "done": "mentally exhausted",
    "broken": "emotionally hurt",
    "helpless": "feeling helpless",
}


def chat_words_analysis(text):
    new_text = []
    for w in text.split():
        if w in chat_words:
            new_text.append(chat_words[w])
        else:
            new_text.append(w)
    return ' '.join(new_text)

# Same clean text function jo training mein use hua hai 

def clean_text(text):
    try:
        text = str(text)
        

        # Converting to lowercase
        text = text.lower() 

        # Removing URLS
        text = re.sub(r'http\S+|www\S+|https\S+', '', text, flags=re.MULTILINE)

        # Removing HTML tags
        text = re.sub(r'<.*?>', '', text)

        # Removing Punctuation
        text = text.translate(str.maketrans('', '', string.punctuation))

        # Chat Words Treatment 
        text = chat_words_analysis(text)
        return text
    except: 
        return ""
    


__main__.clean_chat_text = clean_text


class ChatMLService:
    _instance = None
    _model    = None
    _encoder  = None
    _lock     = threading.Lock()

    def __new__(cls):
        if cls._instance is None:
            cls._instance = super(ChatMLService, cls).__new__(cls)
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
                            "Chat_Analysis_Data",
                            "ChatAnalysisModel.pkl"
                        )
                    )
                    print("CHAT MODEL PATH:", model_path)

                    if not os.path.exists(model_path):
                        raise FileNotFoundError(
                            f"Chat model not found: {model_path}"
                        )

                    with open(model_path, "rb") as f:
                        self._model = pickle.load(f)

                    print("CHAT MODEL LOADED")
        return self._model

    def load_encoder(self):
        if self._encoder is None:
            with self._lock:
                if self._encoder is None:
                    encoder_path = os.path.normpath(
                        os.path.join(
                            settings.BASE_DIR,
                            "..",
                            "models",
                            "Chat_Analysis_Data",
                            "chat_label_encoder.pkl"
                        )
                    )
                    with open(encoder_path, "rb") as f:
                        self._encoder = pickle.load(f)
                    print("CHAT ENCODER LOADED")
        return self._encoder

    def predict(self, message: str) -> str:
        try:
            model   = self.load_model()
            encoder = self.load_encoder()

            # Single message list mein wrap karo
            prediction = model.predict([message])

            # Label decode karo
            category = encoder.inverse_transform(prediction)[0]
            return category

        except Exception as e:
            print(f"Chat ML Error: {e}")
            return "unknown"



chat_ml_service = ChatMLService()