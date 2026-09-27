from sklearn.ensemble import RandomForestRegressor
from sklearn.metrics import mean_absolute_error, r2_score
from sklearn.model_selection import train_test_split
import joblib
import requests
# Historical queue data
response = requests.get(
    "http://localhost:8080/queue/training-data"
)

data = response.json()
if not data:
    print("No training data available.")
    exit()
print("Training records:", len(data))

queue_position = [
    [item["queuePosition"]]
    for item in data
]

waiting_time = [
    [item["waitingDuration"]]
    for item in data
]
hour_of_day = [
    [item["hourOfDay"]]
    for item in data
]
service_time = [
    item["serviceDuration"]
    for item in data
]

# Combine input features
X = [
    [
        queue_position[i][0],
        waiting_time[i][0],
        hour_of_day[i][0]
    ]
    for i in range(len(queue_position))
]

# Create the model
X_train, X_test, y_train, y_test = train_test_split(
    X,
    service_time,
    test_size=0.2,
    random_state=42
)

model = RandomForestRegressor(
    n_estimators=100,
    random_state=42
)
model.fit(X_train, y_train)

predictions = model.predict(X_test)

mae = mean_absolute_error(y_test, predictions)
r2 = r2_score(y_test, predictions)

print("MAE:", mae, "seconds")
print("R²:", r2)
for actual, predicted in zip(y_test, predictions):
    print(
        "Actual:",
        actual,
        "seconds | Predicted:",
        predicted,
        "seconds"
    )
joblib.dump(model, "model.pkl")

print("Model trained successfully!")

# Test prediction
new_customer = [[3, 30, 10]]
prediction = model.predict(new_customer)

print("Predicted service time:", prediction[0], "seconds")