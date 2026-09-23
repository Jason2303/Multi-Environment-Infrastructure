variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "environment" {
  type        = string
  description = "Environment name (dev, staging, prod)"
}

variable "common_tags" {
  type        = map(string)
  description = "Tags applied to all resources"
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
