output "instance_id_mean" {
  description = "ID EC2 instance"
  value       = aws_instance.instanciaSonarQube.id
}

output "instance_public_ip_sonar" {
  description = "Public IP address EC2 instance"
  value       = aws_instance.instanciaSonarQube.public_ip
}


