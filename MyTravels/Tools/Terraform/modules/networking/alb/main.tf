# A generic, reusable, standalone module for deploying an ALB

# consts

locals {
  all_ips = [ "0.0.0.0/0" ]
  tcp_protocol = "tcp"
  http_protocol = "HTTP"
  any_protocol = "-1"
  any_port = 0
  http_port = 80
}

# === laod balancer ===

resource "aws_lb" "lb" {
  name = "${var.env_name}-alb"
  load_balancer_type = "application"
  subnets = var.subnet_ids
  security_groups = [aws_security_group.alb_sg.id]
}

resource "aws_security_group" "alb_sg" {
  name = "${var.env_name}_alb_sg"
  
  ingress {
      from_port = local.http_port
      to_port = local.http_port
      protocol = local.tcp_protocol
      cidr_blocks = local.all_ips
  }

  egress {
      from_port = local.any_port
      to_port = local.any_port
      protocol = local.any_protocol
      cidr_blocks = local.all_ips
  }
}

resource "aws_alb_listener" "http_listener" {
  load_balancer_arn = aws_lb.lb.arn
  port = local.http_port
  protocol = local.http_protocol

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: this page not found"
      status_code = 404 
    }
  }
}