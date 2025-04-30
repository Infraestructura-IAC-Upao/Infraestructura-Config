resource "aws_eip" "maineip" {
    tags = {
      Name = "Main elastic ip"
    }
    
}

terraform {
  backend "s3" {
    bucket = "terraform-state-bere"
    key    = "ElasticIP/terraform.tfstate" 
    region = "us-east-2"
  }
  
}