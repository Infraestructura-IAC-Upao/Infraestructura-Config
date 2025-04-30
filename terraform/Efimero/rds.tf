
resource "aws_db_subnet_group" "bere_db_subnet" {
  name        = "bere-db-subnet"
  description = "Subnets para la base de datos"
  subnet_ids  = [aws_subnet.public_subnet-us-est-2a.id , aws_subnet.public_subnet-us-est-2b.id] # Subnet pública (se puede cambiar a privada si lo prefieres)

  tags = {
    Name = "BereDatabaseSubnetGroup"
  }
}
data "terraform_remote_state" "vpc_id" {
  backend = "s3"
  config = {
    bucket = "terraform-state-bere"
    key    = "ElasticIP/terraform.tfstate"
    region = "us-east-2"
  }
}
resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  description = "Allow DB access from backend EC2"
  vpc_id = data.terraform_remote_state.vpc_id.outputs.VpcIP
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.allow_ssh_http.id] # El SG de tu EC2
  }

    ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    cidr_blocks     = ["190.239.208.213/32"]  # Reemplaza <tu-ip-local> por la IP de tu máquina local
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "bere_db" {
  identifier              = "bere-db"
  engine                  = "postgres"
  engine_version          = "17.2" 
  instance_class          = "db.t3.micro" 
  allocated_storage       = 15
  storage_type            = "gp2"
  db_name                 = "restaurant"
  username                = "restaurant_owner"
  password                = "admin1234"
  port                    = 5432

  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  db_subnet_group_name    = aws_db_subnet_group.bere_db_subnet.name

  backup_retention_period = 0 # Desactiva backups para no salir del Free Tier
  skip_final_snapshot     = true # Evita snapshot obligatorio al destruir
  deletion_protection     = false # Puedes cambiar a true en producción

  publicly_accessible     = false  #Activar para permitir local host
  multi_az                = false

  tags = {
    Name = "BereRDS"
  }
}