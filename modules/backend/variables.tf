variable "region" {
    type = string
}

variable "vpc_id" {
  type = string
}

variable "build_number" {
  type = number
}

variable "public_rt_id" {
  type = string
}

variable "backend_port" {
  type = number
}

variable "backend_key_pair_name" {
  type = string
}

variable "backend_default_az" {
  type = string
}

variable "backend_route53_zone_id" {
  type = string
}

variable "backend_ami_image_id" {
    type = string
}

variable "backend_asg_desired_capacity" {
  type = number
}

variable "backend_spot_instance_price" {
  type = number
}

variable "backend_asg_max_size" {
  type = number
}

variable "backend_user_data_template" {
  type = string
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

variable "backend_subnet_cidr_block_a" {
  type = string
}

variable "backend_subnet_cidr_block_b" {
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

variable "environment" {
  type = string
  description = "An environment name (staging, uat, production, etc.)"
}