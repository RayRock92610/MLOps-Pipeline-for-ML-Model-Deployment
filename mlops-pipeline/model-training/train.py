# Python script to train model and log to MLflow
import pandas as pd
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
import joblib
import mlflow
import mlflow.sklearn

# Load dataset
df = pd.read_csv("https://raw.githubusercontent.com/mwaskom/seaborn-data/master/iris.csv")
X = df.drop("species", axis=1)
y = df["species"]

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2)

# Track with MLflow
mlflow.set_experiment("iris-classifier")
with mlflow.start_run():
    model = RandomForestClassifier()
    model.fit(X_train, y_train)
    
    acc = model.score(X_test, y_test)
    mlflow.log_metric("accuracy", acc)
    mlflow.sklearn.log_model(model, "rf-model")

    joblib.dump(model, "model/model.pkl")
    print("Model trained and saved.")
