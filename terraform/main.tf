provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {}

resource "aws_vpc" "app-demo-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_subnet" "app-demo-subnet" {
  vpc_id            = aws_vpc.app-demo-vpc.id
  cidr_block        = cidrsubnet(aws_vpc.app-demo-vpc.cidr_block, 8, 0)
  availability_zone = "us-west-2a"
}

resource "aws_security_group" "ingress-allow-ssh" {
  name   = "allow-ssh-sg"
  vpc_id = aws_vpc.app-demo-vpc.id
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
  }
  // Terraform removes the default rule
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_internet_gateway" "app-demo-gw" {
  vpc_id = aws_vpc.app-demo-vpc.id
}

resource "aws_route_table" "app-demo-route-table" {
  vpc_id = aws_vpc.app-demo-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.app-demo-gw.id
  }
}

resource "aws_route_table_association" "subnet-association" {
  subnet_id      = aws_subnet.app-demo-subnet.id
  route_table_id = aws_route_table.app-demo-route-table.id
}

resource "aws_key_pair" "mykey" {
  key_name   = var.ssh_private_key_file
  public_key = file("${path.module}/${var.ssh_public_key_file}")
}

resource "aws_instance" "app-demo-server" {
  ami = var.ami

  instance_type               = var.instance_type
  key_name                    = aws_key_pair.mykey.key_name
  subnet_id                   = aws_subnet.app-demo-subnet.id
  vpc_security_group_ids      = [aws_security_group.ingress-allow-ssh.id]
  associate_public_ip_address = true

  tags = {
    Name = "app-demo-server"
  }
}

resource "local_file" "ansible-inventory" {
  filename = "${path.module}/../ansible/inventory"
  content  = templatefile("${path.module}/../ansible/inventory.tmpl", {
    public_ip = aws_instance.app-demo-server.public_ip
  })
}

/*
resource "aws_db_subnet_group" "app-demo-db" {
  name       = "app-demo-db"
  subnet_ids = module.vpc.public_subnets

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
}
*/
/*
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
*/
