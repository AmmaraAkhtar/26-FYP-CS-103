import string
import pickle
import threading
from django.conf import settings
import pandas as pd
import re
import __main__
import os
from dotenv import load_dotenv
import os
import requests

load_dotenv()  # .env file load karo

GROQ_API_KEY = os.getenv("GROQ_API_KEY")


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
    


__main__.clean_text = clean_text


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
                            "chatAnalysisEncoder.pkl"
                        )
                    )
                    with open(encoder_path, "rb") as f:
                        self._encoder = pickle.load(f)
                    print("CHAT ENCODER LOADED")
        return self._encoder
    
    def translate_to_english(self,text: str) -> str:

        """Roman Urdu / Urdu ko English mein translate karo via Grok API"""
        has_urdu_script = bool(re.search(r'[\u0600-\u06FF]', text))
        
        # Step 2: Roman Urdu words check karo
        roman_urdu_words = {
            'hai', 'hain', 'ho', 'tha', 'thi', 'thy', 'ga', 'gi', 'gy',
            'kya', 'nhi', 'nahi', 'mein', 'tum', 'aur', 'kr', 'hy', 'na',
            'ko', 'ki', 'ka', 'sy', 'se', 'par', 'bhi', 'ab', 'koi',
            'kuch', 'acha', 'theek', 'hn', 'hna', 'ap', 'apna', 'apni',
            'mera', 'meri', 'tera', 'teri', 'woh', 'wo', 'yeh', 'ye',
            'phir', 'phr', 'agar', 'lekin', 'mgr', 'bas', 'bss', 'yrr',
            'yaar', 'bhai', 'bhen', 'achi', 'acha', 'sahi', 'thk', 'bilkul'
        }
        
        words = set(text.lower().split())
        has_roman_urdu = bool(words & roman_urdu_words)  # intersection
        
        # Step 3: Sirf tab translate karo jab zaroorat ho
        if not has_urdu_script and not has_roman_urdu:
            print(f"SKIPPED (already English): '{text}'")
            return text  
        try:
            response = requests.post(
                "https://api.groq.com/openai/v1/chat/completions",
                headers={
                    "Content-Type": "application/json",
                    "Authorization": f"Bearer {GROQ_API_KEY}"
                },
                json={
                     "model": "llama-3.1-8b-instant",  
                    "max_tokens": 200,
                    "messages": [
                        {
                            "role": "system",
                            "content": "You are a translator. Your ONLY job is to output the English translation. Rules: 1) No explanations 2) No notes 3) No extra sentences 4) If already English, return exactly as-is 5) If untranslatable, return exactly as-is"
                        },
                        {
                            "role": "user",
                            "content": text
                        }
                    ]
                },
                timeout=10
            )

            data = response.json()
            if "choices" not in data:
                print(f"GROK ERROR RESPONSE: {data}")  
                return text
            translated = data["choices"][0]["message"]["content"].strip()
            print(f"TRANSLATED: '{text}' → '{translated}'")
            return translated

        except Exception as e:
            print(f"Translation error: {e}")
            return text  # fail hone par original return ho ga
        
    
    def classify_with_groq(self, message: str) -> str:
        try:
            response = requests.post(
                "https://api.groq.com/openai/v1/chat/completions",
                headers={
                    "Content-Type": "application/json",
                    "Authorization": f"Bearer {GROQ_API_KEY}"
                },
                json={
                    "model": "llama-3.1-8b-instant",
                    "max_tokens": 10,
                    "messages": [
                        {
                            "role": "system",
                            "content": """You are a chat message classifier for a child safety app.
    Classify the message into exactly ONE of these categories:
    - normal
    - bullying  
    - hate
    - suicide

    Rules:
    1. Return ONLY the category word, nothing else
    2. Be conservative — only classify as dangerous if clearly harmful
    3. Roman Urdu and Urdu messages should also be classified
    4. Casual conversation, school talk, family talk = normal"""
                        },
                        {
                            "role": "user",
                            "content": f"Classify: {message}"
                        }
                    ]
                },
                timeout=10
            )

            data = response.json()
            if "choices" not in data:
                return "normal"
            
            category = data["choices"][0]["message"]["content"].strip().lower()
            valid = {"normal", "bullying", "hate", "suicide"}
            return category if category in valid else "normal"

        except Exception as e:
            print(f"Groq error: {e}")
        return "normal"






    def predict(self, message: str) -> str:
        try:
            model   = self.load_model()
            encoder = self.load_encoder()
            print(f"Original Message: {message}")
            # Making Prediction with ML model
            translated_message = self.translate_to_english(message)
            print(f"Translated Message: {translated_message}")
            prediction = model.predict([ translated_message ])
            ml_category = encoder.inverse_transform(prediction)[0]

            # Checking the confidence level of ML model prediction
            
            proba = model.predict_proba([translated_message])
            confidence = proba.max()  # highest probability
            print(f"ML Prediction: {prediction[0]}, Confidence: {confidence:.2f}")

            if confidence < 0.70:  # 70% se kam confident hai ML
                print(f"LOW CONFIDENCE — asking Groq...")
                groq_category = self.classify_with_groq(message)
                print(f"GROQ OVERRIDE: {prediction[0]} → {groq_category}")
                return groq_category
        
            return ml_category

            

        except Exception as e:
            print(f"Chat ML Error: {e}")
            return "unknown"



chat_ml_service = ChatMLService()