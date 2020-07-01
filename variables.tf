variable "region" {
  type = string
  description = "AWS region ID."
}

variable "build_number" {
  type = number
}

variable "backend_default_az" {
  type = string
}

variable "backend_route53_zone_id" {
  type = string
}

variable "db_vpc_cidr_block" {
  type = string
  description = "CIDR block for the DB VPC"
}

variable "db_availability_zone" {
  type = string
}

variable "db_engine_version" {
  type = string
}

variable "db_performance_insights_enabled" {
  type = bool
}

variable "backend_port" {
  type = number
}

variable "backend_key_pair_name" {
  type = string
}

variable "db_multi_az" {
  type = bool
  description = "Enable Multi AZ"
}

variable "db_instance_class" {
  type = string
  description = "DB EC2 Instance Class"
}


variable "db_allocated_storage" {
  type = number
  description = "DB Allocated Storage"
}

# Backend part

variable "backend_ami_image_id" {
  type = string
}

variable "backend_asg_desired_capacity" {
  type = number
}

variable "backend_asg_max_size" {
  type = number
}

variable "backend_health_check_grace_period" {
  type = number
}

variable "backend_asg_min_size" {
  type = number
}

variable "backend_instance_type" {
  type = string
}

variable "vpc_cidr_block" {
  type = string
  description = "CIDR block for the Backend VPC"
}

variable "backend_subnet_cidr_block_a" {
  type = string
}

variable "backend_subnet_cidr_block_b" {
  type = string
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

variable "backend_availability_zone_a" {
  type = string
  description = "Backend Availability Zone A"
}

variable "backend_availability_zone_b" {
  type = string
  description = "Backend Availability Zone B"
}

variable "public_availability_zone_a" {
  type = string
  description = "Backend Availability Zone A"
}

variable "public_availability_zone_b" {
  type = string
  description = "Backend Availability Zone B"
}

variable "public_availability_zone_c" {
  type = string
  description = "Backend Availability Zone C"
}

variable "backend_spot_instance_price" {
  type = number
}

variable "backend_user_data_template" {
  type = string
}

variable "environment" {
  type = string
  description = "An environment name (staging, uat, production, etc.)"
}
