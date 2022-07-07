terraform {
    backend "s3" {
      bucket = "web-app-terraform-state"
      key = "stage/services/back-end-app/terraform.tfstate"
      region = "us-east-2"
      
      dynamodb_table = "terraform-locks"
      encrypt = true
    }
}

provider "aws" {
  region = "us-east-2"
}

module "back_end" {
  source = "../../../modules/services/back-end-app"

  db_password = var.db_password
  db_remote_state_bucket = "web-app-terraform-state"
  db_remote_state_key = "stage/data-storage/postgresql/terraform.tfstate"
  env_name = "stage"  
}