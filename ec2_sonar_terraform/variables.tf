# Access key personal account
variable "aws_access_key" {
  default = ""
}
# Secret key personal account
variable "aws_secret_key" {
  default = ""
}

variable "ami_sonar" {
  description = "AMI sonar"
  default     = ""
}

variable "aws_region" {
  description = "Region"
  default     = "us-east-1"
}

variable "instance_type" {
  description = "instance type for ec2"
  default     = "t2.medium"
}

variable "prefix" {
  description = "Prefix demo"
  default     = "sonar-demo-devsu"
}
# VPC INFO
variable "vpc_name" {
  default = "demo-devsu-infra-vpc"
}
variable "vpc_cidr" { 
  default = "10.30.0.0/16"
}
# SUBNET INFO
variable "subnet_name" {
  default = "demo-devsu-subnet"
}

variable "subnet_cidr" {
  default = "10.30.10.0/24"
}

variable "map_public_ip_on_launch" {
  default     = true
}
# IGW INFO
variable "igw_name" {
  default = "demo-devsu-igw"
}

# ROUTE TABLE INFO
variable "rt_name" {
  default = "demo-devsu-rt"
}
# ROUTE TABLE INFO
variable "sg_name" {
  default = "demo-devsu-sg"
}  

variable "azs" {
	type = list
	default = ["us-east-1a", "us-east-1b"]
}

# IP privada fija para instancia
variable "ip_sonar" {
  description = "IP instance"
  default     = "10.30.10.5"
}

variable "sonar_docker_compose" {
    type = string
    default =  <<EOF
version: '3'

services:
  sonarqube:
    image: sonarqube
    ports:
      - '9000:9000'
    networks:
      - sonarnet
    environment:
      - sonar.jdbc.username=sonar
      - sonar.jdbc.password=sonar
      - sonar.jdbc.url=jdbc:postgresql://db:5432/sonar
    volumes:
      - sonarqube_conf:/opt/sonarqube/conf
      - sonarqube_data:/opt/sonarqube/data
      - sonarqube_extensions:/opt/sonarqube/extensions
    ulimits:
      nofile:
       soft: 65536
       hard: 65536
  db:
    image: postgres
    networks:
      - sonarnet
    environment:
      - POSTGRES_USER=sonar
      - POSTGRES_PASSWORD=sonar
    volumes:
      - postgresql:/var/lib/postgresql
      - postgresql_data:/var/lib/postgresql/data

networks:
  sonarnet:
    driver: bridge

volumes:
  sonarqube_conf:
  sonarqube_data:
  sonarqube_extensions:
  postgresql:
  postgresql_data:
EOF
}

variable "systemd_after_stage" {
    type = string
    default = "network.target"
}
