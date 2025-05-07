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
  value       = "${local.eip_ip}"
}

# DNS público
output "backend_public_dns" {
  description = "DNS público del backend"
  value       = aws_instance.bere_backend.public_dns
}

output "api_gateway_url" {
  description = "URL pública del API Gateway"
  value       = aws_apigatewayv2_stage.default.invoke_url
}

output "frontend_url" {
  description = "URL del frontent"
  value = local.front_url
  
}

output "api_gateway_id" {
  value = aws_apigatewayv2_api.backend_api.id
}

output "api_gateway_endpoint" {
  value = aws_apigatewayv2_api.backend_api.api_endpoint
}

output "api_gateway_stage" {
  value = aws_apigatewayv2_stage.default.name
}

output "integration_uri" {
  value = aws_apigatewayv2_integration.backend_integration.integration_uri
}

output "backend_eip" {
  value = aws_eip_association.eip_assoc.public_ip
}