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

output "aws_subnet_public_subnet-us-est-2a" {
  description = "vpcIP"
  value       = aws_subnet.public_subnet-us-est-2a.id
}

output "aws_subnet_public_subnet-us-est-2b" {
  description = "vpcIP"
  value       = aws_subnet.public_subnet-us-est-2b.id
}

output "url_front" {
  description = "URL del frontend en CloudFront"
  value       = "https://${aws_cloudfront_distribution.frontend_cf.domain_name}"
}