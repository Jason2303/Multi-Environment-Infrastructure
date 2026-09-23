variable "vpc_id" {
  type        = string
  description = "VPC ID passed from the networking output"
}

variable "private_subnet_id" {
  type        = list(string)
  description = "Private Subnet IDs passed from the networking output"
}

variable "compute_security_group_id" {
  type        = string
  description = "Compute Security Group ID"
}

variable "database_name" {
  type        = string
  description = "database name"
}

variable "database_username" {
  type        = string
  description = "database username"
}

variable "database_password" {
  type        = string
  description = "database password"
  sensitive   = true

  validation {
    condition     = length(var.database_password) >= 16
    error_message = "The db_password must be at least 16 characters long."
  }
}

variable "database_engine" {
  type        = string
  description = "database engine"
  validation {
    condition     = contains(["postgres", "mysql"], var.database_engine)
    error_message = "The db_engine must be a valid MySQL or PostgreSQL variant"
  }
}

variable "database_engine_version" {
  type        = string
  description = "database engine version"
}

variable "database_instance_type" {
  type        = string
  description = "database instance type"
}

variable "database_storage" {
  type        = number
  description = "database storage"
}

variable "environment" {
  type        = string
  description = "Environment name (dev, staging, prod)"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "The environment variable must be one of: dev, staging, or prod."
  }
}

variable "common_tags" {
  type        = map(string)
  description = "Tags applied to all resources"
}

variable "multi_az" {
  type        = bool
  description = "For prod, it's okay. For dev, overkill"
  default     = true
}