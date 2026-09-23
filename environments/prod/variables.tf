variable "instance_type" {
  default     = "t3.micro"
  type        = string
  description = "Instance Type for Dev, Prod & Staging"
}

variable "ami_id" {
  type        = string
  description = "AMI ID"
}

variable "key_pair" {
  type        = string
  description = "Key Pair for SSH access to the instances"
}

variable "asg_sizes" {
  type = object({
    min_size         = number,
    max_size         = number,
    desired_capacity = number
  })
  description = "min, max and desired capacity for ASG"
}

variable "allowed_ssh_cidr" {
  type        = string
  description = "Allowed IP range from which someone can SSH into the instance from"
}

variable "environment" {
  type        = string
  description = "Environment name (dev, staging, prod)"
}

variable "common_tags" {
  type        = map(string)
  description = "Tags applied to all resources"
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
}

variable "database_engine" {
  type        = string
  description = "database engine"
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


variable "multi_az" {
  type        = bool
  description = "For prod, it's okay. For dev, overkill"
  default     = false
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  type = map(object({
    cidr = string
    az   = string
  }))
  description = "Map of public subnets with CIDR and availability zone"
}

variable "private_subnets" {
  type = map(object({
    cidr = string
    az   = string
  }))
  description = "Map of private subnets with CIDR and availability zone"
}

variable "single_nat_gateway" {
  type        = bool
  description = "Use one NAT gateway instead of one per AZ to save cost"
  default     = true
}

variable "email" {
  type = string
  description = "email log metrics will be sent to"
}

variable "cpu_threshold" {
  type = number
  description = "CPU threshold that when crossed triggers CloudWatch alarm"
}

variable "retention_in_days" {
  type = number
  description = "Log Retention in days"
}