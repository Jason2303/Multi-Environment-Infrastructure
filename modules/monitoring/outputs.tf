output "sns_topic_arn" {
  value = aws_sns_topic.topic.arn
  description = "sns topic arn"
}

output "log_group" {
  value = aws_cloudwatch_log_group.app_logs.name
  description = "log group name"
}