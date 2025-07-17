import React, { useEffect, useState } from "react";
import axios from "axios";

export default function ModelVersionList() {
  const [models, setModels] = useState([]);

  useEffect(() => {
    axios.get("http://localhost:8000/models").then((res) => setModels(res.data));
  }, []);

  return (
    <div className="p-4 bg-white rounded shadow">
      <h2 className="text-xl font-bold">Deployed Models</h2>
      <ul className="list-disc pl-6 mt-2">
        {models.map((model) => (
          <li key={model.version}>
            {model.name} - Version {model.version}
          </li>
        ))}
      </ul>
    </div>
  );
}