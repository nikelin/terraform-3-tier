variable "region" {
    type = string
    description = "AWS region ID."
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

variable "db_vpc_cidr_block" {
    type = string
    description = "CIDR block for the DB VPC"
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