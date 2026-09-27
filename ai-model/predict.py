import joblib

# Load the trained model
model = joblib.load("model.pkl")

# Test input
new_customer = [[3, 30]]

# Make prediction
prediction = model.predict(new_customer)

print("Predicted service time:", prediction[0], "seconds")