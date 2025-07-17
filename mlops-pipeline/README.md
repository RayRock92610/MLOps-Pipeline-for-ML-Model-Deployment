# MLOps Pipeline for ML Model Deployment

This project automates the training, versioning, and deployment of ML models using CI/CD and GitOps principles.

## Stack

- Model: scikit-learn
- Registry: MLflow
- Serving: FastAPI
- Infra: AWS (EKS, S3), managed with Terraform
- CI/CD: GitHub Actions
- GitOps: ArgoCD
- Monitoring: Prometheus + Grafana

Automated model training, versioning, and deployment using GitOps.