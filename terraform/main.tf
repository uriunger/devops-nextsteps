provider "aws" {
  region = var.region
}

resource "aws_instance" "app-demo-server" {
  ami           = var.ami
  instance_type = var.instance_type

  tags = {
    Name = "app-demo-server"
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.77.0"

  name                 = "education"
  cidr                 = "10.0.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  public_subnets       = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  enable_dns_hostnames = true
  enable_dns_support   = true
}
