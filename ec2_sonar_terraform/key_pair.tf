# SSH key 
resource "tls_private_key" "ssh_key_ec2-devops" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# aws_key_pair
resource "aws_key_pair" "generated_key_practica" {
  key_name   = "${var.prefix}-ssh-key"
  public_key = tls_private_key.ssh_key_ec2-devops.public_key_openssh

  tags = {
    Name = "SSH key DevOps"
  }
}

# File SSH
resource "local_file" "cloud_pem" {
  filename = "${path.module}/${var.prefix}-ssh-key.pem"
  content  = tls_private_key.ssh_key_ec2-devops.private_key_pem
}
