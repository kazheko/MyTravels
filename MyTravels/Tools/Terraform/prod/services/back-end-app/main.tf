terraform {
  backend "s3" {
    bucket = "web-app-terraform-state"
    key    = "prod/services/back-end-app/terraform.tfstate"
    region = "us-east-2"

    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = "us-east-2"
}

module "back_end" {
  source = "../../../modules/services/back-end-app"

  db_password = var.db_password
  db_remote_state = {
    bucket = "web-app-terraform-state"
    key    = "prod/data-storage/postgresql/terraform.tfstate"
  }
  env_name           = "prod"
  enable_autoscaling = true
}
