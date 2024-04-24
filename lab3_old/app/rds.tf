resource "aws_ssm_parameter" "app_db_password" {
  name  = "/app/db/password"
  type  = "String"
  value = var.db_admin_password

  // Does not reapply the value if it changes
  lifecycle {
    ignore_changes = [value, tags]
  }

  tags = var.default_tags
}

resource "aws_db_instance" "app" {
  allocated_storage = 10
  identifier        = "app-db"
  db_name           = "sc_lab3_app"
  engine            = "mysql"
  engine_version    = "8.0.33"
  instance_class    = "db.t3.micro"
  username          = var.db_admin_user
  password          = var.db_admin_password
  availability_zone = var.aws_availability_zone

  auto_minor_version_upgrade          = false
  network_type                        = "IPV4"
  publicly_accessible                 = false
  db_subnet_group_name                = aws_db_subnet_group.app.name
  vpc_security_group_ids              = [aws_security_group.rds_app.id]
  iam_database_authentication_enabled = true
  skip_final_snapshot                 = true

  tags = var.default_tags
}

// SUBNET GROUP
resource "aws_db_subnet_group" "app" {
  name       = "app-db-subnet-group"
  subnet_ids = module.vpc_with_nat_instance.database_subnet_ids

  tags = var.default_tags
}

// RDS SECURITY GROUP
resource "aws_security_group" "rds_app" {
  name        = "rds-app-sg"
  description = "Security group for the app database"
  vpc_id      = module.vpc_with_nat_instance.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] // TODO: Use app's Security Group
  }

  tags = var.default_tags
}
