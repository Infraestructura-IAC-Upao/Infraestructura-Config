output "elasticIP" {
  description = "elasticIP"
  value       = aws_eip.maineip.public_ip
}

output "elastic_ip_allocation_id" {
  value = aws_eip.maineip.allocation_id
}

output "VpcIP" {
  description = "vpcIP"
  value       = aws_vpc.main.id
}