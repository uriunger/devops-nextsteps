output "ec2_instance_ip" {
  value = aws_instance.app-demo-server.public_ip
}
