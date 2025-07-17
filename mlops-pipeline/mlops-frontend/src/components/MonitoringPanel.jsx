import React from "react";

export default function MonitoringPanel() {
  return (
    <div className="p-4 bg-white rounded shadow space-y-2">
      <h2 className="text-xl font-bold">Model Monitoring</h2>
      <iframe
        src="http://localhost:3000/d/ml-model-dashboard/ml-model-inference-monitoring?orgId=1"
        width="100%"
        height="500"
        frameBorder="0"
      ></iframe>
    </div>
  );
}