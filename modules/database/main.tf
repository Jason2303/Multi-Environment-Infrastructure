resource "aws_security_group" "database" {
  name        = "${var.environment}-database"
  description = "Allow Inbound and Outbound database traffic"
  vpc_id      = var.vpc_id

  tags = merge(var.common_tags, {
    Name = "${var.environment}"
  })
}

resource "aws_vpc_security_group_ingress_rule" "database_inbound" {
  security_group_id            = aws_security_group.database.id
  referenced_security_group_id = var.compute_security_group_id
  from_port                    = local.db_port
  ip_protocol                  = "tcp"
  to_port                      = local.db_port
}

locals {
  # For Postgre & RDS port
  db_port = var.database_engine == "postgres" ? 5432 : (var.database_engine == "mysql" ? 3306 : 0)
}

resource "aws_vpc_security_group_egress_rule" "database_outbound" {
  security_group_id = aws_security_group.database.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "${var.environment}-db_subnet_group"
  subnet_ids = var.private_subnet_id


  tags = merge(var.common_tags, {
    Name = "${var.environment}"
  })
}

resource "aws_db_instance" "db" {
  allocated_storage      = var.database_storage
  db_name                = var.database_name
  engine                 = var.database_engine
  engine_version         = var.database_engine_version
  instance_class         = var.database_instance_type
  username               = var.database_username
  parameter_group_name   = "default.${var.database_engine}"
  skip_final_snapshot    = true
  multi_az               = var.multi_az
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.database.id]
  storage_encrypted      = true
  password               = var.database_password

  tags = merge(var.common_tags, {
    Name = "${var.environment}"
  })
}