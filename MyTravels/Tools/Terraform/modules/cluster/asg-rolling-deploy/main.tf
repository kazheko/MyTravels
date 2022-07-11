# A generic, reusable, standalone module for deploying an ASG 
# that can do a zero-downtime, rolling deployment.

# === consts ===

locals {
  all_ips = [ "0.0.0.0/0" ]
  tcp_protocol = "tcp"
  any_protocol = "-1"
  any_port = 0
}

# === launch config ===

resource "aws_launch_configuration" "launch_config" {
  name_prefix = "${var.env_name}_"
  image_id = "ami-02f3416038bdb17fb"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.launch_config_sg.id]
  user_data = var.user_data

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "launch_config_sg" {
  name = "${var.env_name}_launch_config_sg"
  
  ingress {
    cidr_blocks = local.all_ips
    from_port = var.server_port
    protocol = local.tcp_protocol
    to_port = var.server_port
  }

  egress {
    from_port = local.any_port
    to_port = local.any_port
    protocol = local.any_protocol
    cidr_blocks = local.all_ips
  }  
}

# === autoscaling group ===

resource "aws_autoscaling_group" "main_asg" {
  name = "${aws_launch_configuration.launch_config.name}_asg"
  launch_configuration = aws_launch_configuration.launch_config.name
  vpc_zone_identifier  = var.subnet_ids

  health_check_type = var.health_check_type
  
  min_size = 2
  max_size = 10

  min_elb_capacity = 2

  lifecycle {
    create_before_destroy = true
  }


  tag {
    key = "Name"
    value = "asg_instance"
    propagate_at_launch = true
  }

  target_group_arns = var.target_group_arns
}

module "scaling" {
  source = "../scaling-cloud-watch"

  env_name = var.env_name
  enable_autoscaling = var.enable_autoscaling
  autoscaling_group_name = aws_autoscaling_group.main_asg.name
}
