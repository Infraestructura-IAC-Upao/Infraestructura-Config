data "terraform_remote_state" "Persistente" {
  backend = "s3"
  config = {
    bucket = "terraform-state-bere"
    key    = "Persistente/terraform.tfstate"
    region = "us-east-2"
  }
}

variable "aws_region" {
  default = "us-east-2"
}


locals {
  vpc_id  = data.terraform_remote_state.Persistente.outputs.VpcIP
  eip     = data.terraform_remote_state.Persistente.outputs.elastic_ip_allocation_id
  subnet_2a = data.terraform_remote_state.Persistente.outputs.aws_subnet_public_subnet-us-est-2a
  subnet_2b = data.terraform_remote_state.Persistente.outputs.aws_subnet_public_subnet-us-est-2b
}