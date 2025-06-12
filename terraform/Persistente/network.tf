resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16" 
  enable_dns_support   = true 
  enable_dns_hostnames = true 

  tags = {
    Name = "MainVPC"
  }
}

resource "aws_internet_gateway" "internet-gateway" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-gateway.id
  }
}

resource "aws_route_table_association" "public_subnet-us-est-2a" {
  subnet_id      = aws_subnet.public_subnet-us-est-2a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_subnet-us-est-2b" {
  subnet_id      = aws_subnet.public_subnet-us-est-2b.id
  route_table_id = aws_route_table.public.id
}

resource "aws_subnet" "public_subnet-us-est-2a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24" 
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = false
  tags = {
    Name = "Public Subnet us-east-2a"
  }
}

resource "aws_subnet" "public_subnet-us-est-2b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-2b"
  map_public_ip_on_launch = false
  tags = {
    Name = "Public Subnet us-east-2b"
  }
}

resource "aws_default_security_group" "restricted_default" {
  vpc_id = aws_vpc.main.id
  ingress = []
  egress  = []
  revoke_rules_on_delete = true

  tags = {
    Name = "restricted-default-sg"
  }
}
