resource "aws_cloudwatch_log_group" "app_logs" {
  name = "${var.environment}-logs"
  retention_in_days = var.retention_in_days

  tags = merge(var.common_tags, {
  Name = "${var.environment}-logs"
  })
}

resource "aws_cloudwatch_metric_alarm" "alarm" {
  alarm_name                = "${var.environment}-cpu-alarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 2
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = 120
  statistic                 = "Average"
  threshold                 = var.cpu_threshold
  alarm_description         = "This metric monitors ec2 cpu utilization"
  insufficient_data_actions = []
  dimensions = {
    AutoScalingGroupName = var.asg_name
  }
  alarm_actions = [aws_sns_topic.topic.arn]
}

resource "aws_sns_topic" "topic" {
  name = "${var.environment}-alerts"
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.topic.arn
  protocol  = "email"
  endpoint  = var.email
}