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
