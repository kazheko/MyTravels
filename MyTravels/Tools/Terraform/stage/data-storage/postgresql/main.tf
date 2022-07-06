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

provider "random" {
}

resource "random_password" "password" {
  length = 20
  special = false
  override_special = "_%@"
}

#creates a database in RDS
resource "aws_db_instance" "db" {
  identifier_prefix = "stage"
  engine = "postgres"
  allocated_storage = 5
  instance_class = "db.t3.micro"
  db_name = "mytravels"
  skip_final_snapshot = true
  publicly_accessible  = true
  username = var.db_username
  password = random_password.password.result
  vpc_security_group_ids = [aws_security_group.db_asg.id]
}

resource "aws_security_group" "db_asg" {
  name = "stage_db_asg"
  description = "Allow all inbound for Postgres"
  ingress {
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}