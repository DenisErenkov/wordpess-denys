terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.63.0"
    }
  }
}

terraform {
  backend "s3" {
    bucket = "denys-yerenkov-terraform"
    key    = "terraform"
    region = "eu-central-1"
    profile = "denysyerenkov"
  }
}

provider "aws" {
  region = "eu-central-1"
  profile = "denysyerenkov"
}

module "ec2" {
  source = "./terraform"
  name = var.name 
  db_password = var.db_password 
  
}

