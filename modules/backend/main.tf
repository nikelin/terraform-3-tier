data "aws_availability_zone" "zone_a" {
  name = var.backend_availability_zone_a
}

data "aws_availability_zone" "zone_b" {
  name = var.backend_availability_zone_b
}

output "backend_target_group_arn" {
  value = aws_lb_target_group.backend_load_balancer_tg.arn
}

output "backend_asg_id" {
  value = aws_autoscaling_group.backend_app_asg.id
}

output "backend_subnet_a_id" {
  value = aws_subnet.backend_subnet_a.id
}

output "backend_subnet_b_id" {
  value = aws_subnet.backend_subnet_b.id
}

output "backend_security_group_id" {
  value = aws_security_group.backend_security_group.id
}

resource "aws_subnet" "backend_subnet_a" {
  vpc_id     = var.vpc_id
  cidr_block = var.backend_subnet_cidr_block_a
  availability_zone = data.aws_availability_zone.zone_a.id
  tags = {
    Name = "Private Backend Subnet A"
  }

  map_public_ip_on_launch = false
}

resource "aws_subnet" "backend_subnet_b" {
  vpc_id     = var.vpc_id
  cidr_block = var.backend_subnet_cidr_block_b
  availability_zone = data.aws_availability_zone.zone_b.id
  tags = {
    Name = "Private Backend Subnet B"
  }

  map_public_ip_on_launch = false
}

resource "aws_route_table_association" "backend_vpc_subnet_a_assoc" {
  subnet_id      = aws_subnet.backend_subnet_a.id
  route_table_id = var.public_rt_id
}

resource "aws_route_table_association" "backend_vpc_subnet_b_assoc" {
  subnet_id      = aws_subnet.backend_subnet_b.id
  route_table_id = var.public_rt_id
}

resource "aws_security_group" "backend_security_group" {
  vpc_id = var.vpc_id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

data "aws_ami" "backend_ami" {
  owners           = ["self"]
  filter {
    name = "image-id"
    values = [var.backend_ami_image_id]
  }
}

data "template_file" "backend_app_lc_userdata" {
  template = file("${path.root}/templates/${var.backend_user_data_template}")
  vars = {
    environment = var.environment
    build_number = var.build_number
  }
}

resource "aws_launch_configuration" "backend_app_lc" {
  name_prefix   = "backend_app_lc_${var.environment}_${var.build_number}"
  image_id      =  data.aws_ami.backend_ami.id
  instance_type = var.backend_instance_type
  spot_price    = var.backend_spot_instance_price

  security_groups = [aws_security_group.backend_security_group.id]
  key_name = var.backend_key_pair_name

  user_data = data.template_file.backend_app_lc_userdata.rendered

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_autoscaling_group" "backend_app_asg" {
  name = "backend-alb-tf"

  vpc_zone_identifier = [
    aws_subnet.backend_subnet_a.id,
    aws_subnet.backend_subnet_b.id
  ]

  min_size = var.backend_asg_min_size
  max_size = var.backend_asg_max_size
  desired_capacity = var.backend_asg_desired_capacity

  health_check_type = "ELB"
  health_check_grace_period = var.backend_health_check_grace_period
  target_group_arns = [aws_lb_target_group.backend_load_balancer_tg.arn]
  force_delete = true

  launch_configuration      = aws_launch_configuration.backend_app_lc.name

  tags = [
    {
      key = "Environment"
      value = var.environment
      propagate_at_launch = true
    }
  ]
}

resource "aws_autoscaling_attachment" "backend_app_asg_attachment" {
  depends_on = [aws_lb_target_group.backend_load_balancer_tg]
  alb_target_group_arn = aws_lb_target_group.backend_load_balancer_tg.arn
  autoscaling_group_name = aws_autoscaling_group.backend_app_asg.id
}

resource "aws_lb_target_group" "backend_load_balancer_tg" {
  name     = "backend-target-group"
  port     = var.backend_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  deregistration_delay = 5

  health_check {
    protocol = "HTTP"
    interval = 10
    healthy_threshold = 2
    unhealthy_threshold = 10
    path = "/"
    port = 80
    timeout = 5
    matcher = "200,404,403,401"
  }

  stickiness {
    type = "lb_cookie"
    enabled = true
  }
}