// https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/create-iam-roles-for-cloudwatch-agent-commandline.html
resource "aws_iam_role" "ec2_role" {
  name        = var.role_name
  description = var.role_description

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

  tags = var.default_tags
}

resource "aws_iam_role_policy" "role_inline_policy" {
  count = length(var.inline_policies)
  name  = var.inline_policies[count.index].name
  role  = aws_iam_role.ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = var.inline_policies[count.index].action,
        Effect   = var.inline_policies[count.index].effect,
        Resource = var.inline_policies[count.index].resource
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "managed_policy_role_attachment" {
  count      = length(var.managed_policy_arns)
  role       = aws_iam_role.ec2_role.name
  policy_arn = var.managed_policy_arns[count.index]
}

# Attach this to EC2
resource "aws_iam_instance_profile" "ec2_cloudwatch_instance_profile" {
  name = var.profile_name
  role = aws_iam_role.ec2_role.name

  tags = var.default_tags
}
