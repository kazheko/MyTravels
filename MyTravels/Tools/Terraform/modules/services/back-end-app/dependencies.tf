locals {
  db_config = data.terraform_remote_state.db.outputs
}

data "terraform_remote_state" "db" {
  backend = "s3"

  config = {
    bucket = var.db_remote_state.bucket
    key    = var.db_remote_state.key
    region = "us-east-2"
  }  
}

data "template_file" "user_data" {
  template = file("${path.module}/app-deploy.sh")

  vars = {
    server_port = var.web_port
    db_address = local.db_config.address
    db_port = local.db_config.port
    db_username = local.db_config.username
    db_password = var.db_password
    db_database = local.db_config.db_name
    env = var.env_name
  }
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}