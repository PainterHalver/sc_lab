# resource "aws_iam_role" "ec2_cloudwatch_role" {
#   name        = "CloudWatchAgentServerRole"
#   description = "Role for EC2 CloudWatch agent"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Action = "sts:AssumeRole",
#         Effect = "Allow",
#         Principal = {
#           Service = "ec2.amazonaws.com"
#         }
#       }
#     ]
#   })

#   inline_policy {
#     name = "CloudWatchAgentPutLogsRetention"
#     policy = jsonencode({
#       Version = "2012-10-17",
#       Statement = [
#         {
#           Action = [
#             "logs:PutRetentionPolicy"
#           ],
#           Effect   = "Allow",
#           Resource = "arn:aws:logs:*:*:log-group:LAB-2:*"
#         }
#       ]
#     })
#   }

#   inline_policy {
#     name = "AppDownAlertSNSRole"
#     policy = jsonencode({
#       Version = "2012-10-17",
#       Statement = [
#         {
#           Action = [
#             "sns:Publish"
#           ],
#           Effect   = "Allow",
#           Resource = aws_sns_topic.ec2_app_stop_alert.arn
#         }
#       ]
#     })
#   }

#   tags = var.default_tags
# }

# resource "aws_iam_role_policy_attachment" "ec2_agent_server_role" {
#   role       = aws_iam_role.ec2_cloudwatch_role.name
#   policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
# }

# # Attach this to EC2
# resource "aws_iam_instance_profile" "ec2_cloudwatch_instance_profile" {
#   name = "CloudWatchAgentServerProfile"
#   role = aws_iam_role.ec2_cloudwatch_role.name

#   tags = var.default_tags
# }

# Allow cloudwatch agents with metrics and log retention
module "ec2_cloudwatch_profile" {
  source = "../modules/ec2_profile"

  aws_region   = var.aws_region
  default_tags = var.default_tags

  profile_name     = "CustomCloudWatchAgentServerProfile"
  role_name        = "CustomCloudWatchAgentServerRole"
  role_description = "Role for EC2 CloudWatch agent"

  inline_policies = [
    {
      name     = "CloudWatchAgentPutLogsRetention"
      action   = ["logs:PutRetentionPolicy"]
      effect   = "Allow"
      resource = "arn:aws:logs:*:*:log-group:LAB-2:*"
    },
    {
      name     = "AppDownAlertSNSRole"
      action   = ["sns:Publish"]
      effect   = "Allow"
      resource = aws_sns_topic.ec2_app_stop_alert.arn
    }
  ]

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  ]
}
