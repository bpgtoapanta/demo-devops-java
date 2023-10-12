# Resource create instance EC2-Sonar
resource "aws_instance" "instanciaSonarQube" {
  ami                         = data.aws_ami.latest_ubuntu_linux.id
  key_name                    = "${var.prefix}-ssh-key"
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.devops_sub.id
  vpc_security_group_ids      = [aws_security_group.sonar.id]
  private_ip                  = var.ip_sonar
  user_data                   = data.template_file.config_docker.rendered
  associate_public_ip_address = true
  tags = {
    Name = "instancia_SonarQube"
  }
}

data "aws_ami" "latest_ubuntu_linux" {
    most_recent = true
    owners = ["amazon"]
    filter {
        name = "name"
        values = ["amzn2-ami-hvm-*"]
    }
    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }
}

data "template_file" "config_docker" {
  template = file("templates/config_docker.tpl")
  vars = {
    sonar_docker_compose = var.sonar_docker_compose
    systemd_after_stage = var.systemd_after_stage
  }
}

