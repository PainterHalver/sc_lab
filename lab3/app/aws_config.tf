// RULES require an existing `Recorder`
resource "aws_config_config_rule" "no_unattached_sg" {
  name        = "no_unattached_sg"
  description = "No unattached Security Groups"

  source {
    owner             = "AWS"
    source_identifier = "EC2_SECURITY_GROUP_ATTACHED_TO_ENI"
  }
  depends_on = [aws_config_configuration_recorder.this]
  tags       = var.default_tags
}

resource "aws_config_config_rule" "no_unrestricted_traffic_sg" {
  name        = "no_unrestricted_traffic_sg"
  description = "No unrestricted incoming traffic ('0.0.0.0/0' or '::/0') for all ports in Security Groups"
  source {
    owner             = "AWS"
    source_identifier = "VPC_SG_OPEN_ONLY_TO_AUTHORIZED_PORTS"
  }
  depends_on = [aws_config_configuration_recorder.this]
  tags       = var.default_tags
}

resource "aws_config_config_rule" "required_tags" {
  name        = "required-tags"
  description = "Check if resources have required tags Group:CyberDevOps and Environment:development"
  input_parameters = jsonencode({
    tag1Key   = "Group",
    tag1Value = "CyberDevOps",
    tag2Key   = "Environment",
    tag2Value = "Development"
  })
  source {
    owner             = "AWS"
    source_identifier = "REQUIRED_TAGS"
  }
  depends_on = [aws_config_configuration_recorder.this]
  tags       = var.default_tags
}

// `Recorder` needs `Delivery channel` to start, but `Delivery channel` needs `Recorder` to be created.
// => aws_config_configuration_recorder_status
resource "aws_config_configuration_recorder_status" "this" {
  name       = aws_config_configuration_recorder.this.name
  is_enabled = false // TODO: Change to true
  depends_on = [aws_config_delivery_channel.this]
}

// CONFIG RECORDER
resource "aws_config_configuration_recorder" "this" {
  name     = "my-config-recorder"
  role_arn = aws_iam_role.aws_config.arn

  recording_group {
    all_supported                 = false
    include_global_resource_types = false
    resource_types                = ["AWS::EC2::SecurityGroup"]
  }

  recording_mode {
    recording_frequency = "CONTINUOUS"
  }
}

resource "aws_iam_role" "aws_config" {
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

  // https://docs.aws.amazon.com/config/latest/developerguide/security-iam-awsmanpol.html#security-iam-awsmanpol-AWS_ConfigRole
  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AWS_ConfigRole"]

  // Inline policy to allow S3 access, needed by Delivery Channel
  inline_policy {
    name = "AllowS3Access"
    policy = jsonencode({
      Version = "2012-10-17",
      Statement = [
        {
          Action = [
            "s3:*"
          ],
          Effect = "Allow",
          Resource = [
            aws_s3_bucket.config.arn,
            "${aws_s3_bucket.config.arn}/*"
          ]
        }
      ]
    })
  }

  tags = var.default_tags
}

// DELIVERY CHANNEL
resource "aws_config_delivery_channel" "this" {
  name           = "my-delivery-channel"
  s3_bucket_name = aws_s3_bucket.config.bucket
  depends_on     = [aws_config_configuration_recorder.this]
}

resource "aws_s3_bucket" "config" {
  bucket        = "sc-aws-config-bucket"
  force_destroy = true
  tags          = var.default_tags
}
