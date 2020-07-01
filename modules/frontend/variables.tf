variable "vpc_id" {
  type = string
  description = "VPC ID"
}


variable "environment" {
  type = string
  description = "An environment name (staging, uat, production, etc.)"
}

variable "build_number" {
  type = string
  description = "A current build number"
}

variable "frontend_subnet_cidr_block_a" {
  type = string
}

variable "frontend_subnet_cidr_block_b" {
  type = string
}

variable "frontend_subnet_cidr_block_c" {
  type = string
}

variable "public_availability_zone_a" {
  type = string
  description = "Public Availability Zone A"
}

variable "public_availability_zone_b" {
  type = string
  description = "Public Availability Zone B"
}

variable "public_availability_zone_c" {
  type = string
  description = "Public Availability Zone B"
}

variable "backend_security_group_id" {
  type = string
  description = "Backend Security Group ID"
}