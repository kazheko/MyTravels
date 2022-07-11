# === scaling up ===

resource "aws_cloudwatch_metric_alarm" "scale_up" {
  count = var.enable_autoscaling ? 1 : 0

  alarm_name = "${var.env_name}_scaling_up"
  alarm_description = "Monitors CPU utilization for main ASG"
  
  namespace = "AWS/EC2"

  metric_name = "CPUUtilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold = 70
  statistic = "Average"
  period = "120"
  evaluation_periods = "2"

  alarm_actions = [aws_autoscaling_policy.scale_up[0].arn]

  dimensions = {
    AutoScalingGroupName = var.autoscaling_group_name
  }
}

resource "aws_autoscaling_policy" "scale_up" {
  count = var.enable_autoscaling ? 1 : 0

  name = "${var.env_name}_scaling_up"
  autoscaling_group_name = var.autoscaling_group_name
  adjustment_type = "ChangeInCapacity"
  scaling_adjustment = 1
  cooldown = 120
}

# === scaling down ===

resource "aws_cloudwatch_metric_alarm" "scale_down" {
  count = var.enable_autoscaling ? 1 : 0

  alarm_name = "${var.env_name}_scaling_down"
  alarm_description = "Monitors CPU utilization for main ASG"
  
  namespace = "AWS/EC2"

  metric_name = "CPUUtilization"
  comparison_operator = "LessThanOrEqualToThreshold"
  threshold = 10
  statistic = "Average"
  period = "120"
  evaluation_periods = "2"

  alarm_actions = [aws_autoscaling_policy.scale_down[0].arn]

  dimensions = {
    AutoScalingGroupName = var.autoscaling_group_name
  }
}

resource "aws_autoscaling_policy" "scale_down" {
  count = var.enable_autoscaling ? 1 : 0
 
  name = "${var.env_name}_scaling_down"
  autoscaling_group_name = var.autoscaling_group_name
  adjustment_type = "ChangeInCapacity"
  scaling_adjustment = -1
  cooldown = 120
}