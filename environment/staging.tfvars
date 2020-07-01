# DB
db_multi_az = false
db_instance_class = "db.t2.micro"
db_allocated_storage = 20
db_vpc_cidr_block = "10.0.1.0/24"
db_availability_zone = "ap-southeast-2a"
db_engine_version = 11.0
db_performance_insights_enabled = true

# Backend
vpc_cidr_block = "10.0.0.0/16"
frontend_subnet_cidr_block_a = "10.0.2.0/24"
frontend_subnet_cidr_block_b = "10.0.3.0/24"
frontend_subnet_cidr_block_c = "10.0.4.0/24"
backend_subnet_cidr_block_a = "10.0.5.0/24"
backend_subnet_cidr_block_b = "10.0.6.0/24"

backend_ami_image_id = "ami-089b1ceb8cd7f9779"
backend_instance_type = "t2.micro"
backend_asg_desired_capacity = 1
backend_asg_min_size = 1
backend_asg_max_size = 1
backend_health_check_grace_period = 300
backend_spot_instance_price = 0.009
backend_port = 80
backend_key_pair_name = "platform5-development"
backend_user_data_template = "backend/userdata.tpl.sh"
backend_availability_zone_a = "ap-southeast-2a"
backend_availability_zone_b = "ap-southeast-2b"
backend_route53_zone_id = "Z6W5MV3EKYHZ1"
public_availability_zone_a = "ap-southeast-2a"
public_availability_zone_b = "ap-southeast-2b"
public_availability_zone_c = "ap-southeast-2c"

backend_default_az = "ap-southeast-2a"

# General
region = "ap-southeast-2"
environment = "staging"