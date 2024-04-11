// RULES require an existing `Recorder`
resource "aws_config_config_rule" "no_unattached_sg" {
  name = "No unattached Security Groups"

  source {
    owner             = "AWS"
    source_identifier = "EC2-SECURITY-GROUP-ATTACHED-TO-ENI"
  }
  depends_on = [aws_config_configuration_recorder.config_recorder]
  tags       = var.default_tags
}

resource "aws_config_config_rule" "no_unrestricted_traffic_sg" {
  name = "No unrestricted incoming traffic ('0.0.0.0/0' or '::/0') for all ports in Security Groups"

  source {
    owner             = "AWS"
    source_identifier = "VPC_SG_OPEN_ONLY_TO_AUTHORIZED_PORTS"
  }
  depends_on = [aws_config_configuration_recorder.config_recorder]
  tags       = var.default_tags
}

// `Recorder` needs `Delivery channel` to start, but `Delivery channel` needs `Recorder` to be created. 
// => aws_config_configuration_recorder_status
resource "aws_config_configuration_recorder_status" "foo" {
  name       = aws_config_configuration_recorder.config_recorder.name
  is_enabled = true
  depends_on = [aws_config_delivery_channel.config_delivery_channel]
}

// CONFIG RECORDER
resource "aws_config_configuration_recorder" "config_recorder" {
  name     = "my-config-recorder"
  role_arn = aws_iam_role.aws_config_role.arn

  recording_group {
    all_supported                 = false
    include_global_resource_types = false
    resource_types                = ["AWS::EC2::SecurityGroup"]
  }

  recording_mode {
    recording_frequency = "CONTINUOUS"
  }
}

resource "aws_iam_role" "aws_config_role" {
  name        = "MyAWSConfigRole"
  description = "Role for AWS Config service"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "config.amazonaws.com"
        }
      }
    ]
  })

  managed_policy_arns = ["arn:aws:iam::aws:policy/aws-service-role/AWSConfigServiceRolePolicy"]

  tags = var.default_tags
}

// DELIVERY CHANNEL
resource "aws_config_delivery_channel" "config_delivery_channel" {
  name           = "my-delivery-channel"
  s3_bucket_name = aws_s3_bucket.config_bucket.bucket
  depends_on     = [aws_config_configuration_recorder.config_recorder]
}

resource "aws_s3_bucket" "config_bucket" {
  bucket        = "aws-config-bucket"
  force_destroy = true
  tags          = var.default_tags
}
