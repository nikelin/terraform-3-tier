variable "vpc_id" {
  type = string
}

variable "backend_subnet_ids" {
  type = list(string)
}

data "aws_availability_zone" "db_zone" {
  name = var.db_availability_zone
}

resource "aws_security_group" "db_security_group" {
  vpc_id = var.vpc_id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_subnet" "db_subnet" {
  vpc_id     = var.vpc_id
  cidr_block = var.db_vpc_cidr_block
  availability_zone = data.aws_availability_zone.db_zone.id
  tags = {
    Name = "Private DB Subnet A"
  }

  map_public_ip_on_launch = false
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name = "main"
  subnet_ids = concat(var.backend_subnet_ids, [aws_subnet.db_subnet.id])

  tags = {
    Name = "RDS Main Subnet Group"
  }
}

resource "aws_db_instance" "db_rds_instance" {
  identifier = "treasuredata-db"

  availability_zone = var.db_availability_zone

  vpc_security_group_ids = [aws_security_group.db_security_group.id]

  instance_class = var.db_instance_class

  engine = "postgres"
  engine_version = var.db_engine_version
  performance_insights_enabled = var.db_performance_insights_enabled
  port = 5432
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name

  username = "treasuredata"
  password = "treasuredata"

  allocated_storage = var.db_allocated_storage
  allow_major_version_upgrade = false
  iam_database_authentication_enabled = true
  deletion_protection = false
  skip_final_snapshot = true
  multi_az = var.db_multi_az
}