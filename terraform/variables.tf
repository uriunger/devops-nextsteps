variable "ami" {
  type    = string
  default = "ami-03f8756d29f0b5f21" // ubuntu 22.04 LTS
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "region" {
  default     = "us-west-2"
  description = "AWS region"
}

variable "db_password" {
  description = "RDS root user password"
  default = "TopSecret#0"
  sensitive   = true
}