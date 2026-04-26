from transformers import TFBertForSequenceClassification, BertTokenizer
import tensorflow as tf
import pickle

# load
model = TFBertForSequenceClassification.from_pretrained("chat_severity_model")
tokenizer = BertTokenizer.from_pretrained("chat_severity_tokenizer_model")

with open("chat_severity_encoder.pkl", "rb") as f:
    le = pickle.load(f)

# prediction function
def predict(text):
    inputs = tokenizer(
        text,
        return_tensors="tf",
        truncation=True,
        padding=True,
        max_length=128
    )

    outputs = model(**inputs)
    pred = tf.argmax(outputs.logits, axis=1).numpy()[0]

    return le.inverse_transform([pred])[0]