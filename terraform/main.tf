terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  backend "s3" {
    bucket = "app-demo-terraform-state"
    key    = "key"
    region = "us-west-2"
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "app-demo-server" {
  ami           = "ami-03f8756d29f0b5f21" // ubuntu 22.04 LTS
  instance_type = "t2.micro"

  tags = {
    Name = "app-demo-server"
  }
}
