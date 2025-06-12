resource "aws_eip" "maineip" {
  # checkov:skip=CKV2_AWS_19: EIP is managed separately and associated in another module
    tags = {
      Name = "Main elastic ip"
    }
    
}

terraform {
  backend "s3" {
    bucket = "terraform-state-bere"
    key    = "Persistente/terraform.tfstate" 
    region = "us-east-2"
  }
  
}