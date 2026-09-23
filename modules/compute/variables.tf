variable "vpc_id" {
  type        = string
  description = "VPC ID passed from the networking output"
}

variable "private_subnet_id" {
  type        = list(string)
  description = "Private Subnet IDs passed from the networking output"
}

variable "instance_type" {
  default     = "t3.micro"
  type        = string
  description = "Instance Type for Dev, Prod & Staging"
}

variable "ami_id" {
  type        = string
  description = "AMI ID"

  validation {
    condition     = can(regex("^ami-[a-f0-9]{8,17}$", var.ami_id))
    error_message = "The ami_id must start with 'ami-' followed by 8 or 17 hexadecimal characters (a-f, 0-9)."
  }
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

  validation {
    condition = (
      var.asg_sizes.max_size >= var.asg_sizes.min_size &&
      var.asg_sizes.desired_capacity >= var.asg_sizes.min_size &&
      var.asg_sizes.desired_capacity <= var.asg_sizes.max_size
    )
    error_message = "ASG capacity error: 'max_size' must be >= 'min_size', and 'desired_capacity' must be between them."
  }
}

variable "allowed_ssh_cidr" {
  type        = string
  description = "Allowed IP range from which someone can SSH into the instance from"

  validation {
    condition     = can(cidrhost(var.allowed_ssh_cidr, 0))
    error_message = "The ssh_cidr must be a valid IPv4 CIDR block (e.g., '10.0.0.0/16')."
  }
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