import React, { useState } from "react";
import axios from "axios";

export default function PredictionForm() {
  const [input, setInput] = useState("");
  const [result, setResult] = useState(null);

  const handlePredict = async () => {
    const response = await axios.post("http://localhost:8000/predict", { input });
    setResult(response.data);
  };

  return (
    <div className="p-4 bg-white rounded shadow space-y-4">
      <h2 className="text-xl font-bold">Test Prediction</h2>
      <input
        type="text"
        value={input}
        onChange={(e) => setInput(e.target.value)}
        placeholder="Enter input JSON"
        className="w-full border p-2 rounded"
      />
      <button onClick={handlePredict} className="bg-green-600 text-white px-4 py-2 rounded">
        Predict
      </button>
      {result && <pre className="bg-gray-100 p-2">{JSON.stringify(result, null, 2)}</pre>}
    </div>
  );
}