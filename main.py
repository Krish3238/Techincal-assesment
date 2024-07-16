from flask import Flask
from google.cloud import firestore

app = Flask(__name__)
db = firestore.Client()

@app.route('/')
def hello_world():
    doc_ref = db.collection('messages').document('hello')
    doc = doc_ref.get()
    if doc.exists:
        return doc.to_dict()['content']
    else:
        return "Hello World not found in database"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)