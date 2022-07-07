locals {
  all_ips = [ "0.0.0.0/0" ]
  tcp_protocol = "tcp"
  http_protocol = "HTTP"
  any_protocol = "-1"
  any_port = 0
  http_port = 80
}

resource "aws_launch_configuration" "vm" {
  name_prefix = "${var.env_name}_vm_"
  image_id = "ami-02f3416038bdb17fb"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.vm_sg.id]
  user_data = data.template_file.user_data.rendered
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "vm_sg" {
  name = "${var.env_name}_vm_sg"
  
  ingress {
    cidr_blocks = local.all_ips
    from_port = var.web_port
    protocol = local.tcp_protocol
    to_port = var.web_port
  }

  egress {
    from_port = local.any_port
    to_port = local.any_port
    protocol = local.any_protocol
    cidr_blocks = local.all_ips
  }
}

resource "aws_autoscaling_group" "main_asg" {
  name = "${var.env_name}_asg"
  launch_configuration = aws_launch_configuration.vm.name
  vpc_zone_identifier  = data.aws_subnets.default.ids

  health_check_type = "ELB"
  
  min_size = 2
  max_size = 10
  tag {
    key = "Name"
    value = "asg_instance"
    propagate_at_launch = true
  }

  target_group_arns = [aws_lb_target_group.tg.arn]
}

resource "aws_lb" "lb" {
  name = "${var.env_name}-lb"
  load_balancer_type = "application"
  subnets = data.aws_subnets.default.ids
  security_groups = [aws_security_group.alb_sg.id]
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

resource "aws_lb_listener_rule" "http_istener_rule" {
  listener_arn = aws_alb_listener.http_listener.arn
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

resource "aws_lb_target_group" "tg" {
  name = "${var.env_name}-tg"
  port = var.web_port
  protocol = local.http_protocol
  vpc_id = data.aws_vpc.default.id

  health_check {
    path = "/"
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
