output "security_group_id" {
  value       = aws_security_group.ssh.id
  description = "Security Group ID"
}

output "autoscaling_group_name" {
  value       = aws_autoscaling_group.ec2_asg.name
  description = "Autoscaling Group Name"
}
