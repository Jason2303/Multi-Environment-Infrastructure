variable "environment" {
  type        = string
  description = "Environment name (dev, staging, prod)"
}

variable "common_tags" {
  type        = map(string)
  description = "Tags applied to all resources"
}

variable "email" {
  type = string
  description = "email log metrics will be sent to"
}

variable "asg_name" {
  type = string
  description = "Autoscaling Group Name"
}

variable "cpu_threshold" {
  type = number
  description = "CPU threshold that when crossed triggers CloudWatch alarm"
}

variable "retention_in_days" {
  type = number
  description = "Log Retention in days"
}