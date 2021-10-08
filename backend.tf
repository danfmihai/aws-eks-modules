terraform {
  backend "s3" {
    bucket = "terraform-visual-september"
    key    = "eks/infrastructure/eks-module-data.tfstate"
    region = "us-east-1"
  }
}