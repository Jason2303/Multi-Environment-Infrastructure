output "vpc_id" {
  value       = aws_vpc.main.id
  description = "VPC ID"
}

output "public_subnet" {
  value       = { for i, j in aws_subnet.public : i => j.id }
  description = "Gives all the key:value pairs for all Public subnets"
}

output "private_subnet" {
  value       = { for i, j in aws_subnet.private : i => j.id }
  description = "Gives all the key:value pairs for all Private subnets"
}

