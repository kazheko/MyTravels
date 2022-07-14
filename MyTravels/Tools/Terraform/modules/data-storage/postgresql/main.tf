locals {
  postgres_port = 5432
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
  identifier_prefix = "${var.env_name}-"
  engine = "postgres"
  allocated_storage = 5
  instance_class = "db.t3.micro"
  db_name = var.db_name
  skip_final_snapshot = true
  publicly_accessible  = true
  username = var.db_username
  password = random_password.password.result
  vpc_security_group_ids = [aws_security_group.db_sg.id]
}

resource "aws_security_group" "db_sg" {
  name = "${var.env_name}_db_sg"
  description = "Allow all inbound for Postgres"
  ingress {
    from_port = local.postgres_port
    to_port = local.postgres_port
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}