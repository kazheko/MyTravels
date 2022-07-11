locals {
  http_protocol = "HTTP"
}

module "asg" {
  source = "../../cluster/asg-rolling-deploy"

  env_name = var.env_name
  enable_autoscaling = var.enable_autoscaling
  target_group_arns = [aws_lb_target_group.tg.arn]
  subnet_ids = data.aws_subnets.default.ids
  health_check_type = "ELB"
  user_data = data.template_file.user_data.rendered
  server_port = var.web_port
}

module "alb" {
  source = "../../networking/alb"

  subnet_ids = data.aws_subnets.default.ids
  env_name = var.env_name
}

resource "aws_lb_listener_rule" "http_istener_rule" {
  listener_arn = module.alb.alb_http_listener_arn
  priority = 100
  
  condition {
      path_pattern {
        values = ["*"]
      }
  }

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

resource "aws_lb_target_group" "tg" {
  name = "${var.env_name}-tg"
  port = var.web_port
  protocol = local.http_protocol
  vpc_id = data.aws_vpc.default.id

  health_check {
    path = "/health/live"
    protocol = local.http_protocol
    matcher = "200"
    interval = 15
    timeout = 3
    healthy_threshold = 2
    unhealthy_threshold = 2
  }
}

data "terraform_remote_state" "db" {
  backend = "s3"

  config = {
    bucket = var.db_remote_state_bucket
    key    = var.db_remote_state_key
    region = "us-east-2"
  }  
}

data "template_file" "user_data" {
  template = file("${path.module}/app-deploy.sh")

  vars = {
    server_port = var.web_port
    db_address = data.terraform_remote_state.db.outputs.address
    db_port = data.terraform_remote_state.db.outputs.port
    db_username = var.db_username
    db_password = var.db_password
    db_database = var.db_database
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
