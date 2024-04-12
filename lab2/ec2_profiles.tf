module "ec2_cloudwatch_profile" {
  source = "../modules/ec2_profile"

  aws_region   = var.aws_region
  default_tags = var.default_tags

  profile_name     = "CustomCloudWatchAgentServerProfile"
  role_name        = "CustomCloudWatchAgentServerRole"
  role_description = "Role for EC2 CloudWatch agent"

  inline_policies = [
    {
      name     = "CloudWatchAgentPutLogsRetentionInlinePolicy"
      action   = ["logs:PutRetentionPolicy"]
      effect   = "Allow"
      resource = "arn:aws:logs:*:*:log-group:LAB-2:*"
    },
    {
      name     = "AppDownAlertSNSInlinePolicy"
      action   = ["sns:Publish"]
      effect   = "Allow"
      resource = aws_sns_topic.ec2_app_stop_alert.arn
    }
  ]

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  ]
}
