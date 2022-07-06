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

locals {
  env = "stage"
}

resource "aws_launch_configuration" "vm1" {
  image_id = "ami-02f3416038bdb17fb"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.web_sg.id]
  user_data = data.template_file.user_data.rendered
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "web_sg" {
  name = "web_sg"
  ingress {
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = var.web_port
    protocol = "tcp"
    to_port = var.web_port
  }
}

resource "aws_autoscaling_group" "asg_1" {
  launch_configuration = aws_launch_configuration.vm1.name
  vpc_zone_identifier  = data.aws_subnets.default.ids

  health_check_type = "ELB"
  
  min_size = 2
  max_size = 10
  tag {
    key = "Name"
    value = "asg_instance"
    propagate_at_launch = true
  }

  target_group_arns = [aws_lb_target_group.tg1.arn]
}

resource "aws_lb" "lb" {
  name = "lb"
  load_balancer_type = "application"
  subnets = data.aws_subnets.default.ids
  security_groups = [aws_security_group.sg_alb.id]
}

resource "aws_alb_listener" "http_listener" {
  load_balancer_arn = aws_lb.lb.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: this page not found"
      status_code = 404 
    }
  }
}

resource "aws_lb_listener_rule" "demo" {
  listener_arn = aws_alb_listener.http_listener.arn
  priority = 100
  
  condition {
      path_pattern {
        values = ["*"]
      }
  }

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.tg1.arn
  }
}

resource "aws_security_group" "sg_alb" {
  name = "sg_alb"
  
  ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
      from_port = 0
      to_port = 0
      protocol = -1
      cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb_target_group" "tg1" {
  name = "tg-1"
  port = var.web_port
  protocol = "HTTP"
  vpc_id = data.aws_vpc.default.id

  health_check {
    path = "/"
    protocol = "HTTP"
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
    bucket = "web-app-terraform-state"
    key    = "stage/data-storage/postgresql/terraform.tfstate"
    region = "us-east-2"
  }  
}

data "template_file" "user_data" {
  template = file("app-deploy.sh")

  vars = {
    server_port = var.web_port
    db_address = data.terraform_remote_state.db.outputs.address
    db_port = data.terraform_remote_state.db.outputs.port
    db_username = var.db_username
    db_password = var.db_password
    db_database = var.db_database
    env = local.env
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

