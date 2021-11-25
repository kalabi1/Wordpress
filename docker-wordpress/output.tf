output "docker_ip" {
  value = aws_instance.Docker_Host.public_ip
}