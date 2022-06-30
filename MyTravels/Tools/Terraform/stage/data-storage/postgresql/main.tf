terraform {
    backend "s3" {
      bucket = "web-app-terraform-state"
      key = "stage/data-storage/postgresql/terraform.tfstate"
      region = "us-east-2"
      
      dynamodb_table = "terraform-locks"
      encrypt = true
    }
}

provider "aws" {
  region = "us-east-2"
}

#creates a database in RDS
resource "aws_db_instance" "db" {
  identifier_prefix = "stage"
  engine = "postgres"
  allocated_storage = 5
  instance_class = "db.t3.micro"
  db_name = "mytravels"
  skip_final_snapshot = true 
  username = var.db_username
  password = var.db_password
}