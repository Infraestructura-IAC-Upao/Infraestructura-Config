output "rds_endpoint" {
  description = "Endpoint de la base de datos RDS"
  value       = aws_db_instance.bere_db.endpoint
}

output "rds_connection_url" {
  description = "URL completa de conexión a la base de datos"
  value       = "postgres://${aws_db_instance.bere_db.username}:${aws_db_instance.bere_db.password}@${aws_db_instance.bere_db.endpoint}:5432/${aws_db_instance.bere_db.db_name}"
  sensitive   = true
}

# IP pública
output "backend_public_ip" {
  description = "IP pública del backend"
  value       = data.terraform_remote_state.elastic_ip.outputs.elasticIP
}

# DNS público
output "backend_public_dns" {
  description = "DNS público del backend"
  value       = aws_instance.bere_backend.public_dns
}

output "backend_url" {
  description = "URL de acceso al backend"
  value       = "http://${data.terraform_remote_state.elastic_ip.outputs.elasticIP}:8080"
}

output "frontend_url" {
  description = "URL del frontent"
  value = "http://bere-frontend.s3.${var.aws_region}.amazonaws.com/index.html"
  
}