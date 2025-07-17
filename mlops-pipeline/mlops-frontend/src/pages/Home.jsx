import React from "react";
import ModelUploadForm from "../components/ModelUploadForm";
import PredictionForm from "../components/PredictionForm";
import ModelVersionList from "../components/ModelVersionList";
import MonitoringPanel from "../components/MonitoringPanel";

export default function Home() {
  return (
    <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
      <ModelUploadForm />
      <PredictionForm />
      <ModelVersionList />
      <MonitoringPanel />
    </div>
  );
}