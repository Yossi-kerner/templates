##############################
# General Configuration
##############################

variable "project_name" {
  description = "The name of the project being deployed"
  type        = string
  default     = "acme-infra"
}

variable "environment" {
  description = "The environment to deploy (e.g., dev, staging, prod)"
  type        = string
  default     = "staging"
}

variable "region" {
  description = "The cloud region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

##############################
# Networking
##############################

variable "vpc_cidr" {
  description = "CIDR block for the main VPC"
  type        = string
  default     = "10.42.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.42.1.0/24", "10.42.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.42.10.0/24", "10.42.11.0/24"]
}

##############################
# Compute
##############################

variable "instance_type" {
  description = "Instance type for EC2 instances"
  type        = string
  default     = "t3.medium"
}

variable "instance_count" {
  description = "Number of EC2 instances to launch"
  type        = number
  default     = 3
}

variable "enable_auto_scaling" {
  description = "Whether to enable auto-scaling for the compute group"
  type        = bool
  default     = true
}

##############################
# Security
##############################

variable "allowed_ips" {
  description = "List of IP addresses allowed to access the application"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "enable_encryption" {
  description = "Enable data-at-rest encryption for storage resources"
  type        = bool
  default     = true
}

variable "admin_username" {
  description = "Username for administrative access"
  type        = string
  default     = "infra-admin"
}

##############################
# Storage
##############################

variable "s3_bucket_name" {
  description = "Name of the S3 bucket for storing artifacts"
  type        = string
  default     = "acme-infra-artifacts"
}

variable "retention_days" {
  description = "Number of days to retain backups"
  type        = number
  default     = 30
}

##############################
# Tags
##############################

variable "tags" {
  description = "A map of common tags to apply to resources"
  type        = map(string)
  default = {
    Owner       = "devops-team"
    Environment = "staging"
    ManagedBy   = "Terraform"
  }
}
