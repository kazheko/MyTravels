terraform {
    backend "s3" {
      bucket = "web-app-terraform-state"
      key = "prod/data-storage/postgresql/terraform.tfstate"
      region = "us-east-2"
      
      dynamodb_table = "terraform-locks"
      encrypt = true
    }
}

provider "aws" {
  region = "us-east-2"
}

module "db" {
  source = "../../../modules/data-storage/postgresql"

  env_name = "prod"
}