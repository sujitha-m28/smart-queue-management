from flask import Flask, request, jsonify
import joblib

app = Flask(__name__)

# Load trained ML model
model = joblib.load("model.pkl")


@app.route("/")
def home():
    return "AI Prediction API is running!"


@app.route("/predict", methods=["POST"])
def predict():

    data = request.get_json()

    queue_position = data["queuePosition"]
    waiting_time = data["waitingTime"]
    hour_of_day = data["hourOfDay"]

    prediction = model.predict([
        [queue_position, waiting_time, hour_of_day]
    ])

    return jsonify({
        "predictedServiceTime": prediction[0]
    })

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
