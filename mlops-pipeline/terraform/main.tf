# AWS provider
provider "aws" {
  region = var.region
}

# EKS Cluster
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = var.cluster_name
  cluster_version = "1.24"
  subnets         = var.subnet_ids
  vpc_id          = var.vpc_id
  enable_irsa     = true
}

# S3 bucket for model artifacts
resource "aws_s3_bucket" "model_storage" {
  bucket         = "${var.cluster_name}-ml-models"
  force_destroy  = true

  tags = {
    Name        = "ML Model Bucket"
    Environment = "dev"
  }
}

# S3 public access block
resource "aws_s3_bucket_public_access_block" "block" {
  bucket = aws_s3_bucket.model_storage.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# IAM policy to access the S3 bucket
resource "aws_iam_policy" "s3_read_write_policy" {
  name   = "EKS_S3_ReadWrite"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Effect   = "Allow"
        Resource = [
          "${aws_s3_bucket.model_storage.arn}",
          "${aws_s3_bucket.model_storage.arn}/*"
        ]
      }
    ]
  })
}
