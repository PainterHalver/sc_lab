// https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/create-iam-roles-for-cloudwatch-agent-commandline.html
resource "aws_iam_role" "this" {
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

resource "aws_iam_role_policy" "inline" {
  count = length(var.inline_policies)
  name  = var.inline_policies[count.index].name
  role  = aws_iam_role.this.id

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

resource "aws_iam_role_policy_attachment" "managed" {
  count      = length(var.managed_policy_arns)
  role       = aws_iam_role.this.name
  policy_arn = var.managed_policy_arns[count.index]
}

# Attach this to EC2
resource "aws_iam_instance_profile" "this" {
  name = var.profile_name
  role = aws_iam_role.this.name

  tags = var.default_tags
}
