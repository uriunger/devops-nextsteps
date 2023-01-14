terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  backend "s3" {
    bucket = "app-demo-terraform-state"
    key    = "terraform-state"
    region = "us-west-2"
  }
  required_version = ">= 1.2.0"
}
