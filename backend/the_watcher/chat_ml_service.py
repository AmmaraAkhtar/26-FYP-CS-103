# import string
# import pickle
# import threading
# from django.conf import settings
# import pandas as pd
# import re
# import __main__
# import os
# from dotenv import load_dotenv
# import os
# import requests

# load_dotenv()  # .env file load karo

# GROQ_API_KEY = os.getenv("GROQ_API_KEY")


# chat_words = {
    
#     "u": "you",
#     "ur": "your",
#     "r": "are",
#     "btw": "by the way",
#     "idk": "i do not know",
#     "imo": "in my opinion",
#     "imho": "in my humble opinion",
#     "lol": "laughing out loud",
#     "lmao": "laughing my ass off",
#     "rofl": "rolling on floor laughing",
#     "omg": "oh my god",
#     "omw": "on my way",
#     "brb": "be right back",
#     "bbl": "be back later",
#     "ttyl": "talk to you later",
#     "gtg": "got to go",
#     "gr8": "great",
#     "b4": "before",
#     "2day": "today",
#     "2moro": "tomorrow",
#     "luv": "love",
#     "k": "okay",
#     "kk": "okay",
#     "okie": "okay",
#     "pls": "please",
#     "plz": "please",
#     "thx": "thanks",
#     "ty": "thank you",
#     "np": "no problem",
#     "smh": "shaking my head",
#     "tbh": "to be honest",
#     "fomo": "fear of missing out",
#     "bae": "before anyone else",
#     "lit": "amazing",
#     "salty": "angry or bitter",
#     "sus": "suspicious",
#     "dm": "direct message",
#     "rn": "right now",
#     "af": "as f***",
#     "ikr": "i know right",
#     "yolo": "you only live once",
#     "ftw": "for the win",
#     "idc": "i do not care",
#     "wyd": "what are you doing",
#     "wya": "where you at",
#     "hbu": "how about you",
#     "afaik": "as far as i know",
#     "tldr": "too long didn't read",

#     "fr": "for real",
#     "ngl": "not gonna lie",
#     "fs": "for sure",
#     "dead": "very funny / shocked",
#     "no cap": "no lie",
#     "cap": "lie",
#     "lowkey": "slightly",
#     "highkey": "obviously",
#     "vibes": "feelings / mood",
#     "mood": "relatable feeling",
#     "slay": "doing great",
#     "fire": "excellent",
#     "mid": "average / bad",
#     "hits different": "feels unique",

   
#     "cuz": "because",
#     "coz": "because",
#     "bc": "because",
#     "bcz": "because",
#     "pls": "please",
#     "plz": "please",
#     "msg": "message",
#     "txt": "text",
#     "grl": "girl",
#     "boi": "boy",

   
#     "gg": "good game",
#     "wp": "well played",
#     "noob": "beginner",
#     "afk": "away from keyboard",
#     "ppl": "people",
#     "ez": "easy",
#     "nerf": "weaken",
#     "buff": "strengthen",

#     "i cant": "i cannot",
#     "cant take it": "cannot handle situation",
#     "done": "mentally exhausted",
#     "broken": "emotionally hurt",
#     "helpless": "feeling helpless",
# }


# def chat_words_analysis(text):
#     new_text = []
#     for w in text.split():
#         if w in chat_words:
#             new_text.append(chat_words[w])
#         else:
#             new_text.append(w)
#     return ' '.join(new_text)

# # Same clean text function jo training mein use hua hai 

# def clean_text(text):
#     try:
#         text = str(text)
        

#         # Converting to lowercase
#         text = text.lower() 

#         # Removing URLS
#         text = re.sub(r'http\S+|www\S+|https\S+', '', text, flags=re.MULTILINE)

#         # Removing HTML tags
#         text = re.sub(r'<.*?>', '', text)

#         # Removing Punctuation
#         text = text.translate(str.maketrans('', '', string.punctuation))

#         # Chat Words Treatment 
#         text = chat_words_analysis(text)
#         return text
#     except: 
#         return ""
    

    


# __main__.clean_text = clean_text


# class ChatMLService:
#     _instance = None
#     _model    = None
#     _encoder  = None
#     _lock     = threading.Lock()

#     def __new__(cls):
#         if cls._instance is None:
#             cls._instance = super(ChatMLService, cls).__new__(cls)
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
#                             "Chat_Analysis_Data",
#                             "ChatAnalysisModel.pkl"
#                         )
#                     )
#                     print("CHAT MODEL PATH:", model_path)

#                     if not os.path.exists(model_path):
#                         raise FileNotFoundError(
#                             f"Chat model not found: {model_path}"
#                         )

#                     with open(model_path, "rb") as f:
#                         self._model = pickle.load(f)

#                     print("CHAT MODEL LOADED")
#         return self._model

#     def load_encoder(self):
#         if self._encoder is None:
#             with self._lock:
#                 if self._encoder is None:
#                     encoder_path = os.path.normpath(
#                         os.path.join(
#                             settings.BASE_DIR,
#                             "..",
#                             "models",
#                             "Chat_Analysis_Data",
#                             "chatAnalysisEncoder.pkl"
#                         )
#                     )
#                     with open(encoder_path, "rb") as f:
#                         self._encoder = pickle.load(f)
#                     print("CHAT ENCODER LOADED")
#         return self._encoder
        
    
#     def translate_to_english(self,text: str) -> str:

#         """Roman Urdu / Urdu ko English mein translate karo via Grok API"""
#         has_urdu_script = bool(re.search(r'[\u0600-\u06FF]', text))
        
#         # Step 2: Roman Urdu words check karo
#         roman_urdu_words = {
#             'hai', 'hain', 'ho', 'tha', 'thi', 'thy', 'ga', 'gi', 'gy',
#             'kya', 'nhi', 'nahi', 'mein', 'tum', 'aur', 'kr', 'hy', 'na',
#             'ko', 'ki', 'ka', 'sy', 'se', 'par', 'bhi', 'ab', 'koi',
#             'kuch', 'acha', 'theek', 'hn', 'hna', 'ap', 'apna', 'apni',
#             'mera', 'meri', 'tera', 'teri', 'woh', 'wo', 'yeh', 'ye',
#             'phir', 'phr', 'agar', 'lekin', 'mgr', 'bas', 'bss', 'yrr',
#             'yaar', 'bhai', 'bhen', 'achi', 'acha', 'sahi', 'thk', 'bilkul'
#         }
        
#         words = set(text.lower().split())
#         has_roman_urdu = bool(words & roman_urdu_words)  # intersection
        
#         # Step 3: Sirf tab translate karo jab zaroorat ho
#         if not has_urdu_script and not has_roman_urdu:
#             print(f"SKIPPED (already English): '{text}'")
#             return text  
#         try:
#             response = requests.post(
#                 "https://api.groq.com/openai/v1/chat/completions",
#                 headers={
#                     "Content-Type": "application/json",
#                     "Authorization": f"Bearer {GROQ_API_KEY}"
#                 },
#                 json={
#                      "model": "llama-3.1-8b-instant",  
#                     "max_tokens": 200,
#                     "messages": [
#                         {
#                             "role": "system",
#                             "content": "You are a translator. Your ONLY job is to output the English translation. Rules: 1) No explanations 2) No notes 3) No extra sentences 4) If already English, return exactly as-is 5) If untranslatable, return exactly as-is"
#                         },
#                         {
#                             "role": "user",
#                             "content": text
#                         }
#                     ]
#                 },
#                 timeout=10
#             )

#             data = response.json()
#             if "choices" not in data:
#                 print(f"GROK ERROR RESPONSE: {data}")  
#                 return text
#             translated = data["choices"][0]["message"]["content"].strip()
#             print(f"TRANSLATED: '{text}' → '{translated}'")
#             return translated
        

#         except Exception as e:
#             print(f"Translation error: {e}")
#             return text  # fail hone par original return ho ga
        

        
    
#     def classify_with_groq(self, message: str) -> str:
#         try:
#             response = requests.post(
#                 "https://api.groq.com/openai/v1/chat/completions",
#                 headers={
#                     "Content-Type": "application/json",
#                     "Authorization": f"Bearer {GROQ_API_KEY}"
#                 },
#                 json={
#                     "model": "llama-3.1-8b-instant",
#                     "max_tokens": 10,
#                     "messages": [
#                         {
#                             "role": "system",
#                             "content": """You are a chat message classifier for a child safety app.
#     Classify the message into exactly ONE of these categories:
#     - normal
#     - bullying  
#     - hate
#     - suicide

#     Rules:
#     1. Return ONLY the category word, nothing else
#     2. Be conservative — only classify as dangerous if clearly harmful
#     3. Roman Urdu and Urdu messages should also be classified
#     4. Casual conversation, school talk, family talk = normal"""
#                         },
#                         {
#                             "role": "user",
#                             "content": f"Classify: {message}"
#                         }
#                     ]
#                 },
#                 timeout=10
#             )

#             data = response.json()
#             if "choices" not in data:
#                 return "normal"
            
#             category = data["choices"][0]["message"]["content"].strip().lower()
#             valid = {"normal", "bullying", "hate", "suicide"}
#             return category if category in valid else "normal"

#         except Exception as e:
#             print(f"Groq error: {e}")
#         return "normal"

        



#     def predict(self, message: str) -> str:
#         try:
#             model   = self.load_model()
#             encoder = self.load_encoder()
#             print(f"Original Message: {message}")
#             # Making Prediction with ML model
#             translated_message = self.translate_to_english(message)
#             print(f"Translated Message: {translated_message}")
#             prediction = model.predict([ translated_message ])
#             ml_category = encoder.inverse_transform(prediction)[0]
#             # Safety net — agar ML "normal" keh raha hai lekin keyword match hota hai, override karo
#             if ml_category == "normal":
#                 kw_result = keyword_check(translated_message)
#                 if kw_result:
#                     print(f"KEYWORD OVERRIDE: normal → {kw_result}")
#                     return kw_result

#             return ml_category

      

#             # Verifying Sensitive Categories with Groq for better accuracy (Groq final decision leta hai)
#             # if ml_category in ["hate", "bullying", "suicide"]:
#             #     print(f"SENSITIVE — verifying with Groq...")
#             #     groq_category = self.classify_with_groq(message)
#             #     print(f"GROQ SAYS: {groq_category}")
#             #     return groq_category  # Groq final decision leta hai

        
#             return ml_category

            

#         except Exception as e:
#             print(f"Chat ML Error: {e}")
#             return "unknown"



# chat_ml_service = ChatMLService()


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


# ─────────────────────────────────────────────────────────────
# KEYWORD SAFETY NET
# ML model abhi training data ki kami ki wajah se kuch obvious
# hate/bullying/suicide messages ko "normal" predict kar raha hai.
# Yeh keyword list ek safety net ke tor par kaam karti hai —
# agar ML "normal" kahe lekin yeh high-risk phrases match ho jayen,
# toh category override kar dete hain. Child-safety app mein
# false negative (real risk ko "normal" mark karna) sabse bara
# risk hai, isliye conservative approach behtar hai.
# ─────────────────────────────────────────────────────────────

SUICIDE_KEYWORDS = [
    "kill myself", "end my life", "want to die", "wanna die",
    "suicide", "take my own life", "no reason to live",
    "better off dead", "i don't want to live", "i dont want to live",
    "khud ko mar", "marna chahta", "marna chahti", "mar jaun",
    "mar jaun ga", "mar jaun gi", "jeena nahi chahta", "jeena nahi chahti",
    "khudkushi",
]

HATE_BULLYING_KEYWORDS = [
    "i hate you", "i hate u", "hate you", "hate u",
    "you are stupid", "you're stupid", "ur stupid",
    "you are ugly", "you're ugly", "ur ugly",
    "shut up loser", "kill yourself", "kys",
    "you are worthless", "ur worthless",
    "nobody likes you", "no one likes you",
    "you are useless", "ur useless",
    "you are dumb", "you're dumb", "ur dumb",
    "i hate u so much", "i hate you so much",
    "tum bewakoof", "tum gandi", "tu ganda",
    "tujhse nafrat", "mujhe tumse nafrat",
    "tum buri ho", "tum bura ho",
]


def keyword_check(text: str):
    """
    Returns 'suicide' or 'hate' if a high-risk phrase is found,
    otherwise returns None.
    """
    lower = text.lower()

    for kw in SUICIDE_KEYWORDS:
        if kw in lower:
            return "suicide"

    for kw in HATE_BULLYING_KEYWORDS:
        if kw in lower:
            return "hate"

    return None


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
        """
        Groq se message classify karwata hai.
        Agar Groq fail ho ya response parse na ho, "normal" return karta hai
        (caller is fallback ko sirf "escalation check" ke liye use karega,
        kabhi bhi ML ke sensitive result ko downgrade nahi karega).
        """
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
                            "content": """You are a SAFETY classifier for a child-monitoring app. A child's chat message will be shown to you. Your job is to flag anything that COULD be harmful to the child — err on the side of caution.

Classify the message into exactly ONE of these categories:
- normal
- bullying
- hate
- suicide

Guidance (be cautious, not dismissive):
1. "suicide" = any mention of self-harm, wanting to die, hopelessness about living, "kill myself", "end it all", "I don't want to live", etc. — even if it sounds like a joke or exaggeration, flag it as "suicide".
2. "hate" = insults, slurs, statements expressing hatred or contempt toward a person ("I hate you", "you are stupid/ugly/worthless", etc.).
3. "bullying" = threats, mocking, exclusion, humiliation directed at someone.
4. "normal" = casual conversation, school talk, family talk, jokes between friends with NO insults, threats, or self-harm references.
5. Roman Urdu and Urdu messages must also be classified using the same rules.
6. When unsure between "normal" and a risk category, choose the risk category.

Return ONLY the single category word, nothing else."""
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
                print(f"GROQ ERROR RESPONSE: {data}")
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

            prediction = model.predict([translated_message])
            ml_category = encoder.inverse_transform(prediction)[0]
            print(f"ML CATEGORY: {ml_category}")

            # ── ML already sensitive — keep it, never let anything downgrade it ──
            if ml_category in ["hate", "bullying", "suicide"]:
                return ml_category

            # ── ML says "normal" — double-check with two safety nets ──
            # 1) Keyword safety net (fast, offline, catches obvious phrases)
            kw_result = keyword_check(translated_message)
            if kw_result:
                print(f"KEYWORD OVERRIDE: normal -> {kw_result}")
                return kw_result

            # 2) Groq escalation check (catches what keywords/ML miss).
            #    Groq can only ESCALATE "normal" to a risk category here —
            #    it can never downgrade, since we only call it when
            #    ml_category == "normal" and kw_result == None.
            groq_category = self.classify_with_groq(message)
            if groq_category in ["hate", "bullying", "suicide"]:
                print(f"GROQ ESCALATION: normal -> {groq_category}")
                return groq_category

            return "normal"

        except Exception as e:
            print(f"Chat ML Error: {e}")
            return "unknown"


chat_ml_service = ChatMLService()