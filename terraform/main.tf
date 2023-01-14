provider "aws" {
  region = var.region
}

resource "aws_key_pair" "openvpn" {
  key_name   = var.ssh_private_key_file
  public_key = file("${path.module}/${var.ssh_public_key_file}")
}

resource "aws_instance" "app-demo-server" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = aws_key_pair.openvpn.key_name

  tags = {
    Name = "app-demo-server"
  }
}

/*
data "aws_availability_zones" "available" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.77.0"

  name                 = "app-demo-vpc"
  cidr                 = "10.0.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  public_subnets       = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_db_subnet_group" "app-demo-db" {
  name       = "app-demo-db"
  subnet_ids = module.vpc.public_subnets

  tags = {
    Name = "app-demo-db"
  }
}

resource "aws_security_group" "rds" {
  name   = "app-demo-db"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "app-demo-db"
  }
}

resource "aws_db_parameter_group" "app-demo-db" {
  name   = "app-demo-db"
  family = "mysql5.7"
}

resource "aws_db_instance" "app-demo-db" {
  identifier             = "app-demo-db"
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  engine                 = "mysql"
  engine_version         = 5.7
  username               = "uri"
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.app-demo-db.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  parameter_group_name   = aws_db_parameter_group.app-demo-db.name
  publicly_accessible    = true
  skip_final_snapshot    = true
}*/
