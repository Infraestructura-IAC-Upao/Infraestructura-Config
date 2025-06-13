resource "aws_cloudfront_origin_access_identity" "frontend_oai" {
  comment = "Access for CloudFront to bere-frontend"
}

# checkov:skip=CKV2-AWS-47: No se usa WAF en esta distribución; protección externa se maneja por otros medios
# checkov:skip=CKV_AWS_310: No se requiere failover en esta distribución, es de un solo origen
# checkov:skip=CKV_AWS_174: Se utiliza certificado por defecto de CloudFront, sin opción a forzar TLS v1.2, ACM genera costos
resource "aws_cloudfront_distribution" "frontend_cf" {
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  origin {
    domain_name = aws_s3_bucket.Bere_frontend.bucket_regional_domain_name
    origin_id   = "s3-origin"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.frontend_oai.cloudfront_access_identity_path
    }
  }

    custom_error_response {
    error_code            = 403
    response_code         = 200
    response_page_path    = "/index.html"
  }

  custom_error_response {
    error_code            = 404
    response_code         = 200
    response_page_path    = "/index.html"
  }
  
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "s3-origin"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    
    response_headers_policy_id = "67f7725c-6f97-4210-82d7-5512b31e9d03"
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "PE"]
    }
  }

  # checkov:skip=CKV2-AWS-42: Usamos certificado por defecto de CloudFront en este entorno
  viewer_certificate {
    cloudfront_default_certificate = true
  }



  tags = {
    Environment = "prod"
  }
}