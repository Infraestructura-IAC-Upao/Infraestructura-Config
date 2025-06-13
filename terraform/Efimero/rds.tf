
resource "aws_db_subnet_group" "bere_db_subnet" {
  name        = "bere-db-subnet"
  description = "Subnets para la base de datos"
  subnet_ids  = [local.subnet_2a, local.subnet_2b] 

  tags = {
    Name = "BereDatabaseSubnetGroup"
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  description = "Allow DB access from backend EC2"
  vpc_id = "${local.vpc_id}"

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.allow_ssh_http.id] 
    description     = "Allow PostgreSQL access from the allow_ssh_http security group"
  }

    ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    cidr_blocks     = ["190.239.208.213/32"]  
    description     = "Allow PostgreSQL access from the specific IP 190.239.208.213"
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
    description = "Allow all outbound traffic"
  }
}

# checkov:skip=CKV_AWS_157: Entorno no requiere alta disponibilidad
# checkov:skip=CKV_AWS_86: No se requiere logging en entorno no productivo
resource "aws_db_instance" "bere_db" {
  # checkov:skip=CKV_AWS_118: No se requiere monitoreo mejorado en este entorno
  identifier                        = "bere-db"
  engine                            = "postgres"
  engine_version                    = "17.2"
  instance_class                    = "db.t3.micro"
  allocated_storage                 = 15
  storage_type                      = "gp2"
  storage_encrypted                 = true
  db_name                           = "restaurant"
  username                          = var.db_username
  password                          = var.db_password
  port                              = 5432

  vpc_security_group_ids            = [aws_security_group.rds_sg.id]
  db_subnet_group_name              = aws_db_subnet_group.bere_db_subnet.name

  backup_retention_period           = 0
  skip_final_snapshot               = true
  iam_database_authentication_enabled = true
  deletion_protection               = false

  publicly_accessible               = false
  multi_az                          = false

  copy_tags_to_snapshot             = true
  auto_minor_version_upgrade        = true

  performance_insights_enabled      = true
  performance_insights_retention_period = 7

  parameter_group_name              = aws_db_parameter_group.bere_db_pg.name


  tags = {
    Name = "BereRDS"
  }
}

resource "aws_db_parameter_group" "bere_db_pg" {
  name   = "bere-db-params"
  family = "postgres17"

  parameter {
    name  = "log_statement"
    value = "all"
  }

  parameter {
    name  = "log_min_duration_statement"
    value = "0"
  }
}

