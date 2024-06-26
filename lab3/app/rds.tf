resource "random_password" "app_db" {
  special = false
  length  = 12
}

resource "aws_ssm_parameter" "app_db_password" {
  name  = "/app/db/password"
  type  = "String"
  value = random_password.app_db.result

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
  password          = random_password.app_db.result
  availability_zone = var.aws_availability_zone

  auto_minor_version_upgrade          = false
  network_type                        = "IPV4"
  publicly_accessible                 = false
  db_subnet_group_name                = aws_db_subnet_group.app.name
  vpc_security_group_ids              = [aws_security_group.rds_app.id]
  iam_database_authentication_enabled = true
  skip_final_snapshot                 = true

  lifecycle {
    ignore_changes = [password]
  }

  tags = var.default_tags
}

// ROUTE 53 RECORD
resource "aws_route53_record" "rds" {
  zone_id = var.route53_zone_id
  name = "rds.${var.route53_zone_name}"
  type = "CNAME"
  ttl = "60"

  records = [aws_db_instance.app.address]
}

// SUBNET GROUP
resource "aws_db_subnet_group" "app" {
  name       = "app-db-subnet-group"
  subnet_ids = var.database_subnet_ids

  tags = var.default_tags
}

// RDS SECURITY GROUP
resource "aws_security_group" "rds_app" {
  name        = "rds-app-sg"
  description = "Security group for the app database"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] // TODO: Use app's Security Group
  }

  tags = var.default_tags
}
