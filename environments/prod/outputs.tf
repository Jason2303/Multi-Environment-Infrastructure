output "vpc_id" {
  value       = module.networking.vpc_id
  description = "The VPC ID"
}

output "private_subnet_id" {
  value       = module.networking.private_subnet
  description = "Private Subnets ID"
}

output "public_subnet_id" {
  value       = module.networking.public_subnet
  description = "Public Subnets ID"
}

output "hostname" {
  value       = module.database.hostname
  description = "Hostname of the database"
}

output "asg_name" {
  value       = module.compute.autoscaling_group_name
  description = "Autoscaling Group name"
}

output "sns_topic_arn" {
  value = module.monitoring.sns_topic_arn
  description = "sns topic arn"
}

output "log_group" {
  value = module.monitoring.log_group
  description = "log group name"
}
