resource "aws_autoscaling_group" "asg" {
  name                = "csye6225-asg"
  max_size            = 3
  min_size            = 1
  desired_capacity    = 1
  default_cooldown    = 60
  vpc_zone_identifier = [for s in aws_subnet.public_subnets : s.id]

  tag {
    key                 = "csye6225"
    value               = "webapp"
    propagate_at_launch = true
  }

  launch_template {
    id      = aws_launch_template.csye6225_lt.id
    version = "$Latest"
  }

  target_group_arns = [
    aws_lb_target_group.alb_tg.arn
  ]

}

# scale up 
resource "aws_autoscaling_policy" "scale-up-policy" {
  name                   = "scale-up-policy"
  autoscaling_group_name = aws_autoscaling_group.asg.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "1"
  cooldown               = "60"
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "scale-up-cpu-alarm" {
  alarm_name          = "scale-up-cpu-alarm"
  alarm_description   = "scale-up-cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "5"
  dimensions = {
    "AutoScalingGroupName" = "${aws_autoscaling_group.asg.name}"
  }
  actions_enabled = true
  alarm_actions   = ["${aws_autoscaling_policy.scale-up-policy.arn}"]
}

# scale down 
resource "aws_autoscaling_policy" "scale-down-policy" {
  name                   = "scale down policy"
  autoscaling_group_name = aws_autoscaling_group.asg.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1"
  cooldown               = "60"
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "scale-down-cpu-alarm" {
  alarm_name          = "scale-down-cpu-alarm"
  alarm_description   = "scale-down-cpu-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "3"
  dimensions = {
    "AutoScalingGroupName" = "${aws_autoscaling_group.asg.name}"
  }
  actions_enabled = true
  alarm_actions   = ["${aws_autoscaling_policy.scale-down-policy.arn}"]
}
