output "database_name" {
  value       = var.database_name
  description = "Database name"
}

output "database_port" {
  value       = local.db_port
  description = "Database port"
}

output "hostname" {
  value       = aws_db_instance.db.address
  description = "Database Hostname(endpoint)"
}