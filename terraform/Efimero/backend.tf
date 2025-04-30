provider "aws" {
  region = "${var.aws_region}" 
  profile = "default"
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file("/home/upao/.ssh/id_rsa.pub") 
}

resource "aws_security_group" "allow_ssh_http" {
  name        = "allow_ssh_http"
  description = "Allow SSH and 8080"
  vpc_id = aws_vpc.main.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "terraform_remote_state" "elastic_ip" {
  backend = "s3"
  config = {
    bucket = "terraform-state-bere"
    key    = "ElasticIP/terraform.tfstate"
    region = "us-east-2"
  }
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.bere_backend.id
  allocation_id = data.terraform_remote_state.elastic_ip.outputs.elastic_ip_allocation_id
}

resource "aws_instance" "bere_backend" {
  ami                         = "ami-0100e595e1cc1ff7f" 
  instance_type               = "t2.micro"
  subnet_id              = aws_subnet.public_subnet-us-est-2a.id
  key_name                    = aws_key_pair.deployer.key_name
  vpc_security_group_ids      = [aws_security_group.allow_ssh_http.id]
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              exec > /var/log/user-data.log 2>&1
              set -xe  
              echo "Esperando red..."

              sleep 30

              sudo dnf clean all
              sudo dnf makecache

              sudo dnf install -y docker
              sudo systemctl start docker
              sudo systemctl enable docker

              sudo docker pull govench/bere-api:latest
              sudo docker run -d -p 8080:8080 --restart always govench/bere-api:latest

              sudo dnf install postgresql17 -y

              echo "Script completado"
              EOF

  tags = {
    Name = "BereBackendEC2"
  }
}