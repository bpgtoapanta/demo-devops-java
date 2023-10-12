# Security Group instance sonar
resource "aws_security_group" "sonar" {
  name        = "sonar-sg"
  vpc_id      = aws_vpc.devops_vpc.id
  description = "Allow ingress traffic HTTP y SSH"

  ingress {
    description = "Requests HTTP"
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Access SSH Bastion"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SonarQube-SG"
  }
}
