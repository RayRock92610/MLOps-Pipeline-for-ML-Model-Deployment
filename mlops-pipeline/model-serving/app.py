# FastAPI server loading model and serving predictions
from fastapi import FastAPI
import joblib
import pandas as pd
from pydantic import BaseModel

app = FastAPI()
model = joblib.load("model.pkl")

class IrisInput(BaseModel):
    sepal_length: float
    sepal_width: float
    petal_length: float
    petal_width: float

@app.post("/predict")
def predict(input: IrisInput):
    data = pd.DataFrame([input.dict()])
    pred = model.predict(data)
    return {"prediction": pred[0]}
