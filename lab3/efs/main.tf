resource "aws_efs_file_system" "efs_for_app" {
  performance_mode       = "generalPurpose"
  availability_zone_name = var.aws_availability_zone
  throughput_mode        = "elastic"

  tags = merge(var.default_tags, {
    Name = "efs-for-app"
  })
}

resource "aws_efs_mount_target" "efs_mount_target" {
  file_system_id  = aws_efs_file_system.efs_for_app.id
  subnet_id       = var.subnet_id
  security_groups = [aws_security_group.efs_sg.id]
}

resource "aws_security_group" "efs_sg" {
  name   = "efs-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr] # TODO: Restrict this
  }

  tags = var.default_tags
}
