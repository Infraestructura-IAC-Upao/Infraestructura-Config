resource "aws_s3_bucket" "Bere_frontend" {
  bucket         = "bere-frontend"
  force_destroy  = true
}

resource "aws_s3_bucket_versioning" "bere_frontend_versioning" {
  bucket = aws_s3_bucket.Bere_frontend.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.Bere_frontend.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "bere_frontend_lifecycle" {
  bucket = aws_s3_bucket.Bere_frontend.id

  rule {
    id     = "delete-old-objects"
    status = "Enabled"

    expiration {
      days = 2
    }

    filter {
      prefix = ""
    }
  }
}

resource "aws_s3_bucket_website_configuration" "frontend_website" {
  bucket = aws_s3_bucket.Bere_frontend.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

resource "aws_s3_bucket_policy" "frontend_bucket_policy" {
  bucket = aws_s3_bucket.Bere_frontend.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = {
          AWS = aws_cloudfront_origin_access_identity.frontend_oai.iam_arn
        }
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.Bere_frontend.arn}/*"
      }
    ]
  })

  depends_on = [
    aws_s3_bucket_public_access_block.bere_frontend_block
  ]
}

resource "aws_s3_bucket_public_access_block" "bere_frontend_block" {
  bucket = aws_s3_bucket.Bere_frontend.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
