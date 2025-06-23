provider "aws" {
  region = "${var.aws_region}" 
  profile = "default"
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file("/home/upao/.ssh/id_rsa.pub") 
}


resource "aws_security_group" "allow_ssh_http" {
  # checkov:skip=CKV_AWS_24: Acceso SSH público temporalmente habilitado por motivos de desarrollo y pruebas
  name        = "allow_ssh_http"
  description = "Allow SSH and 8080"
  vpc_id = "${local.vpc_id}"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow SSH access from anywhere"
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    security_groups = [aws_security_group.sg-lb.id]
    description = "Allow HTTP (port 8080) from load balancer"
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow outbound HTTP traffic"
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow outbound tcp traffic"
  }

  egress {
  from_port   = 5432
  to_port     = 5432
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  description = "Allow outbound postgre traffic"
  }

}



resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.bere_backend.id
  allocation_id = "${local.eip}"
}



resource "aws_instance" "bere_backend" {
  # checkov:skip=CKV_AWS_126: El monitoreo detallado no es necesario en este entorno, evita costos adicionales
  ami                         = "ami-0100e595e1cc1ff7f" 
  instance_type               = "t2.micro"
  subnet_id                   = "${local.subnet_2a}"
  key_name                    = aws_key_pair.deployer.key_name
  vpc_security_group_ids      = [aws_security_group.allow_ssh_http.id]
  associate_public_ip_address = false
  ebs_optimized = true

  metadata_options {
    http_tokens = "required"
    http_endpoint = "enabled"
  }

  root_block_device {
    encrypted = true
  }

  user_data = <<-EOF
              #!/bin/bash
              exec > /var/log/user-data.log 2>&1
              set -xe  
              echo "Esperando red..."

              sleep 30

              sudo dnf clean all
              sudo dnf makecache
              
              sudo dnf install -y git
              sudo dnf install -y docker
              sudo dnf install java-21-amazon-corretto-devel -y
              sudo dnf install -y maven
              sudo systemctl start docker
              sudo systemctl enable docker

              sudo mkdir -p /opt/bere-backend
              cd /opt/bere-backend
              sudo git clone -b iacdevelop https://github.com/DonaBere-Restaurant/Backend.git bere-api
              cd bere-api
              cd RestaurantBere-api/
              sudo JAVA_HOME=/usr/lib/jvm/java-21-amazon-corretto.x86_64 mvn clean package -DskipTests
              
              sudo docker pull govench/bere-api:latest
              sudo docker run -d --name bere-api -p 8080:8080 --restart always govench/bere-api:latest
              
              EOF

  tags = {
    Name = "BereBackendEC2"
  }

  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name

}
resource "aws_instance" "bere_backend_2" {
  # checkov:skip=CKV_AWS_126: El monitoreo detallado no es necesario en este entorno, evita costos adicionales
  ami                         = "ami-0100e595e1cc1ff7f" 
  instance_type               = "t2.micro"
  subnet_id                   = "${local.subnet_2a}"
  key_name                    = aws_key_pair.deployer.key_name
  vpc_security_group_ids      = [aws_security_group.allow_ssh_http.id]
  associate_public_ip_address = true
  ebs_optimized = true

  metadata_options {
    http_tokens = "required"
    http_endpoint = "enabled"
  }

  root_block_device {
    encrypted = true
  }

  user_data = <<-EOF
              #!/bin/bash
              exec > /var/log/user-data.log 2>&1
              set -xe  
              echo "Esperando red..."

              sleep 30

              sudo dnf clean all
              sudo dnf makecache
              
              sudo dnf install -y git
              sudo dnf install -y docker
              sudo dnf install java-21-amazon-corretto-devel -y
              sudo dnf install -y maven
              sudo systemctl start docker
              sudo systemctl enable docker

              sudo mkdir -p /opt/bere-backend
              cd /opt/bere-backend
              sudo git clone -b iacdevelop https://github.com/DonaBere-Restaurant/Backend.git bere-api
              cd bere-api
              cd RestaurantBere-api/
              sudo JAVA_HOME=/usr/lib/jvm/java-21-amazon-corretto.x86_64 mvn clean package -DskipTests
              
              sudo docker pull govench/bere-api:latest
              sudo docker run -d --name bere-api -p 8080:8080 --restart always govench/bere-api:latest
              
              EOF

  tags = {
    Name = "BereBackendEC2-2"
  }

  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name

}

resource "aws_iam_role" "ec2_instance_role" {
  name = "ec2-instance-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Effect = "Allow",
        Sid = ""
      }
    ]
  })
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2-instance-profile"
  role = aws_iam_role.ec2_instance_role.name
}

