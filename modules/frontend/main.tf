variable "backend_asg_id" {
  type = string
}

variable "backend_target_group_arn" {
  type = string
}

variable "public_rt_id" {
  type = string
}

variable "backend_port" {
  type = number
}

data "aws_security_group" "backend_security_group" {
  id = var.backend_security_group_id
}

resource "aws_subnet" "public_vpc_subnet_a" {
  vpc_id     = var.vpc_id
  cidr_block = var.frontend_subnet_cidr_block_a
  availability_zone = var.public_availability_zone_a
  tags = {
    Name = "Public Frontend Subnet A"
  }
  map_public_ip_on_launch = true
}

resource "aws_subnet" "public_vpc_subnet_b" {
  vpc_id     = var.vpc_id
  cidr_block = var.frontend_subnet_cidr_block_b
  availability_zone = var.public_availability_zone_b
  tags = {
    Name = "Public Frontend Subnet B"
  }

  map_public_ip_on_launch = true
}

resource "aws_subnet" "public_vpc_subnet_c" {
  vpc_id     = var.vpc_id
  cidr_block = var.frontend_subnet_cidr_block_c
  availability_zone = var.public_availability_zone_c
  tags = {
    Name = "Public Frontend Subnet C"
  }

  map_public_ip_on_launch = true
}

resource "aws_route_table_association" "public_vpc_subnet_c_assoc" {
  subnet_id      = aws_subnet.public_vpc_subnet_c.id
  route_table_id = var.public_rt_id
}

resource "aws_route_table_association" "public_vpc_subnet_b_assoc" {
  subnet_id      = aws_subnet.public_vpc_subnet_b.id
  route_table_id = var.public_rt_id
}

resource "aws_route_table_association" "public_vpc_subnet_a_assoc" {
  subnet_id      = aws_subnet.public_vpc_subnet_a.id
  route_table_id = var.public_rt_id
}

resource "aws_lb" "backend_load_balancer" {
  name               = "public-app-lb"

  internal           = false
  load_balancer_type = "application"
  security_groups    = [data.aws_security_group.backend_security_group.id]
  subnets            = [
    aws_subnet.public_vpc_subnet_a.id,
    aws_subnet.public_vpc_subnet_b.id,
    aws_subnet.public_vpc_subnet_c.id
  ]

  enable_deletion_protection = false

  tags = {
    Environment = var.environment
  }
}

resource "aws_lb_listener" "backend_load_balancer_listener" {
  load_balancer_arn = aws_lb.backend_load_balancer.arn
  port              = var.backend_port
  protocol          = "HTTP"

  default_action {
    target_group_arn = var.backend_target_group_arn
    type             = "forward"
  }
}