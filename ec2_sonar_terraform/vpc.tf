# VPC
resource "aws_vpc" "devops_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    "Name" = var.vpc_name
  }
}
# SUBNET
# aws_subnet.devops_sub:
resource "aws_subnet" "devops_sub" {
  vpc_id                  = aws_vpc.devops_vpc.id
  availability_zone       = element(var.azs,1)
  cidr_block              = var.subnet_cidr
  map_public_ip_on_launch = var.map_public_ip_on_launch
  tags = {
    "Name" = "${var.subnet_name}_1"
  }


  timeouts {}
}

# Internet Gateway
# aws_internet_gateway.devops_igw:
resource "aws_internet_gateway" "devops_igw" {
  vpc_id = aws_vpc.devops_vpc.id
  tags = {
    "Name" = var.igw_name
  }
}
# Route Table
# aws_route_table.devops_rt:
resource "aws_route_table" "devops_rt" {
  vpc_id = aws_vpc.devops_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.devops_igw.id
  }

  tags = {
    "Name" = var.rt_name
  }

}

# aws_route_table_association.devops_rt_sub:
resource "aws_route_table_association" "devops_rt_sub_1" {
  route_table_id = aws_route_table.devops_rt.id
  subnet_id      = aws_subnet.devops_sub.id
}
