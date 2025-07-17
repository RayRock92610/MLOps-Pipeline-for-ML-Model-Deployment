import React from "react";

export default function ModelUploadForm() {
  return (
    <form className="p-4 bg-white rounded shadow space-y-4">
      <h2 className="text-xl font-bold">Train New Model</h2>
      <input type="file" name="trainingData" className="block" />
      <button className="bg-blue-500 text-white px-4 py-2 rounded">Upload & Train</button>
    </form>
  );
}