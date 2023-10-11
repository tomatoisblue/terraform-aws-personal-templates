resource "aws_launch_configuration" "default" {
  name            = "${var.prefix}-launch-config"
  image_id        = var.ami
  instance_type   = var.instance_type
  key_name        = var.key_name
  security_groups = [aws_security_group.default.id]
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "default" {
  name                      = "${var.prefix}-auto-scaling-group"
  max_size                  = 4
  min_size                  = 2
  desired_capacity          = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  force_delete              = true
  launch_configuration      = aws_launch_configuration.default.id
  vpc_zone_identifier       = [aws_subnet.public[0].id, aws_subnet.public[1].id]
  termination_policies      = ["NewestInstance"]
  lifecycle {
    create_before_destroy = true
    ignore_changes        = [load_balancers, target_group_arns]
  }
}

resource "aws_autoscaling_attachment" "default" {
  autoscaling_group_name = aws_autoscaling_group.default.id
  lb_target_group_arn    = aws_lb_target_group.default.arn
}


resource "aws_autoscaling_group_tag" "default" {
  autoscaling_group_name = aws_autoscaling_group.default.name
  tag {
    key                 = "Name"
    value               = "AutoScaled-EC2"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "scale_out" {
  name                   = "Instance-ScaleOut-CPU-High"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.default.name
}

resource "aws_autoscaling_policy" "scale_in" {
  name                   = "Instance-ScaleIn-CPU-Low"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.default.name
}

resource "aws_cloudwatch_metric_alarm" "scale_out" {
  alarm_name          = "CPU-Utilization-High-40"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "40"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.default.name
  }
  alarm_actions = [aws_autoscaling_policy.scale_out.arn]
}

resource "aws_cloudwatch_metric_alarm" "scale_in" {
  alarm_name          = "CPU-Utilization-Low-5"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "30"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.default.name
  }
  alarm_actions = [aws_autoscaling_policy.scale_in.arn]
}