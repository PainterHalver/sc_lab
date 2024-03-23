// https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/create-iam-roles-for-cloudwatch-agent-commandline.html

resource "aws_iam_role" "ec2_cloudwatch_role" {
  name        = "CloudWatchAgentServerRole"
  description = "Role for EC2 CloudWatch agent"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  // Allow setting log retention
  // https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/create-iam-roles-for-cloudwatch-agent-commandline.html#CloudWatch-Agent-PutLogRetention
  inline_policy {
    name = "CloudWatchAgentPutLogsRetention"
    policy = jsonencode({
      Version = "2012-10-17",
      Statement = [
        {
          Action = [
            "logs:PutRetentionPolicy"
          ],
          Effect   = "Allow",
          Resource = "*"
        }
      ]
    })
  }

  tags = var.default_tags
}

resource "aws_iam_role_policy_attachment" "ec2_agent_server_role" {
  role       = aws_iam_role.ec2_cloudwatch_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# Attach this to EC2
resource "aws_iam_instance_profile" "ec2_cloudwatch_instance_profile" {
  name = "CloudWatchAgentServerProfile"
  role = aws_iam_role.ec2_cloudwatch_role.name

  tags = var.default_tags
}
