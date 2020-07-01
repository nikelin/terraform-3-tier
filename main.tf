provider "terraform" {}
provider "template" {}

provider "aws" {
  profile = "default"
  region = var.region
}

resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc_internet_gw.id
  }

  tags = {
    Name = "vpc-route-table"
  }
}

resource "aws_internet_gateway" "vpc_internet_gw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "vpc-internet-gateway"
  }
}

module "backend" {
  source = "./modules/backend"

  # Networking
  public_rt_id = aws_route_table.public_rt.id

  # General
  region = var.region
  vpc_id = aws_vpc.vpc.id
  build_number = var.build_number
  environment = var.environment

  # Backend specific
  backend_port = var.backend_port
  backend_key_pair_name = var.backend_key_pair_name
  backend_spot_instance_price = var.backend_spot_instance_price
  backend_asg_desired_capacity = var.backend_asg_desired_capacity
  backend_asg_min_size = var.backend_asg_min_size
  backend_asg_max_size = var.backend_asg_max_size
  backend_health_check_grace_period = var.backend_health_check_grace_period
  backend_instance_type = var.backend_instance_type
  backend_ami_image_id = var.backend_ami_image_id
  backend_subnet_cidr_block_a = var.backend_subnet_cidr_block_a
  backend_subnet_cidr_block_b  = var.backend_subnet_cidr_block_b
  backend_user_data_template = var.backend_user_data_template
  backend_availability_zone_a = var.backend_availability_zone_a
  backend_availability_zone_b = var.backend_availability_zone_b
  backend_route53_zone_id = var.backend_route53_zone_id
  backend_default_az = var.backend_default_az
}

module "db" {
  source = "./modules/db"
  region = var.region
  vpc_id = aws_vpc.vpc.id
  backend_subnet_ids = [module.backend.backend_subnet_a_id, module.backend.backend_subnet_b_id]
  db_availability_zone = var.db_availability_zone
  db_vpc_cidr_block = var.db_vpc_cidr_block
  db_multi_az = var.db_multi_az
  db_allocated_storage = var.db_allocated_storage
  db_instance_class = var.db_instance_class
  db_performance_insights_enabled = var.db_performance_insights_enabled
  db_engine_version  = var.db_engine_version
}

module "frontend" {
  source = "./modules/frontend"

  # general
  environment = var.environment
  vpc_id = aws_vpc.vpc.id
  build_number = var.build_number

  # networking
  public_rt_id = aws_route_table.public_rt.id

  #backend

  backend_asg_id = module.backend.backend_asg_id
  backend_target_group_arn = module.backend.backend_target_group_arn
  backend_port = var.backend_port

  frontend_subnet_cidr_block_a = var.frontend_subnet_cidr_block_a
  frontend_subnet_cidr_block_b = var.frontend_subnet_cidr_block_b
  frontend_subnet_cidr_block_c = var.frontend_subnet_cidr_block_c

  public_availability_zone_a = var.public_availability_zone_a
  public_availability_zone_c = var.public_availability_zone_b
  public_availability_zone_b = var.public_availability_zone_c
  backend_security_group_id = module.backend.backend_security_group_id
}

terraform {
  required_version = "~> 0.10"
}
