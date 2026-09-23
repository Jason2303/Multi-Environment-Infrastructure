variable "backend_bucket" {
  type        = string
  default     = "backend-bucket-3112"
  description = "Bucket containing the state file"
}

variable "region" {
  type        = string
  default     = "us-east-1"
  description = "Region for AWS resources"
  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]{1}$", var.region))
    error_message = "Must be a valid AWS region format (e.g., us-east-1)."
  }
}