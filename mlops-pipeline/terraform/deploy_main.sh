#!/bin/bash

# =============================================================================
# MLOps Pipeline - Terraform Main Configuration Wrapper
# Purpose: Deploy AWS infrastructure for ML model storage & EKS cluster
# =============================================================================

set -euo pipefail

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Script configuration
SCRIPT_DIR="$(cd ""){dirname "${BASH_SOURCE[0]}"} && pwd)"
TERRAFORM_DIR="${SCRIPT_DIR}"
MAIN_TF_FILE="${TERRAFORM_DIR}/main.tf"

# =============================================================================
# FUNCTIONS
# =============================================================================

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

check_prerequisites() {
    log_info "Checking prerequisites..."
    
    if ! command -v terraform &> /dev/null; then
        log_error "Terraform is not installed"
        exit 1
    fi
    
    if ! command -v aws &> /dev/null; then
        log_error "AWS CLI is not installed"
        exit 1
    fi
    
    log_info "Prerequisites check passed"
}

tf_init() {
    log_info "Initializing Terraform..."
    cd "${TERRAFORM_DIR}"
    terraform init
    log_info "Terraform initialized"
}

tf_plan() {
    log_info "Running Terraform plan..."
    cd "${TERRAFORM_DIR}"
    terraform plan -out=tfplan
    log_info "Terraform plan completed"
}

tf_apply() {
    log_info "Applying Terraform configuration..."
    cd "${TERRAFORM_DIR}"
    
    read -p "Do you want to apply these changes? (yes/no): " -r
    if [[ $REPLY =~ ^[Yy][Ee][Ss]$ ]]; then
        terraform apply tfplan
        log_info "Infrastructure deployed successfully"
    else
        log_warn "Apply cancelled by user"
    fi
}

tf_destroy() {
    log_warn "This will destroy all AWS resources created by Terraform"
    read -p "Are you sure? Type 'yes' to confirm: " -r
    
    if [[ $REPLY == "yes" ]]; then
        cd "${TERRAFORM_DIR}"
        terraform destroy
        log_info "Infrastructure destroyed"
    else
        log_info "Destroy cancelled"
    fi
}

tf_show_outputs() {
    log_info "Terraform Outputs:"
    cd "${TERRAFORM_DIR}"
    terraform output
}

# =============================================================================
# MAIN
# =============================================================================

main() {
    local action="${1:-help}"
    
    case "${action}" in
        init)
            check_prerequisites
            tf_init
            ;; 
        plan)
            check_prerequisites
            tf_plan
            ;;
        apply)
            check_prerequisites
            tf_apply
            ;;
        destroy)
            check_prerequisites
            tf_destroy
            ;;
        outputs)
            tf_show_outputs
            ;;
        *)
            cat << 'HELP_EOF'
╔═══════════════════════════════════════════════════════════════════════════╗
║        MLOps Pipeline - Terraform Configuration Wrapper                   ║
╚═══════════════════════════════════════════════════════════════════════════╝

USAGE:
  ./deploy_main.sh <action>

ACTIONS:
  init       - Initialize Terraform and create configuration files
  plan       - Plan infrastructure changes (dry-run)
  apply      - Apply Terraform configuration to AWS
  destroy    - Destroy all AWS resources
  outputs    - Display Terraform outputs
  help       - Show this help message

EXAMPLE:
  ./deploy_main.sh init      # Initialize
  ./deploy_main.sh plan      # Preview changes
  ./deploy_main.sh apply     # Deploy to AWS

PREREQUISITES:
  - Terraform CLI installed
  - AWS CLI configured with credentials
  - AWS IAM permissions for EKS and S3

ENVIRONMENT VARIABLES:
  Set these in terraform.tfvars or as environment variables:
  - AWS_REGION
  - TF_VAR_cluster_name
  - TF_VAR_vpc_id
  - TF_VAR_subnet_ids

HELP_EOF
            ;;
    esac
}

main "$@"