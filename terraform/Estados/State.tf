resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-state-bere"
  force_destroy = true
  tags = {
    Name = "TerraformStateBucket"
  }
  # checkov:skip=CKV_AWS_144: Bucket dedicado a los estados de Terraform, replicación entre regiones no es necesaria
  # checkov:skip=CKV2_AWS_62: No necesitamos eventos en este bucket.
  # checkov:skip=CKV_AWS_18: No se habilita el logging ya que genera costos adicionales y altera la arquitectura diseñada sin bucket de logs
  
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket_lifecycle_configuration" "states_lifecycle" {
  bucket = aws_s3_bucket.terraform_state.id

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

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "public_block" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls  = true
  restrict_public_buckets = true
}