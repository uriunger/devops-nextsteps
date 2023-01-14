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

variable "ssh_public_key_file" {
  # Generate via 'ssh-keygen -f openvpn -t rsa'
  description = "The public SSH key to store in the EC2 instance"
  default     = "terraform/openvpn.pub"
}

variable "ssh_private_key_file" {
  # Generate via 'ssh-keygen -f openvpn -t rsa'
  description = "The private SSH key used to connect to the EC2 instance"
  default     = "terraform/openvpn"
}
