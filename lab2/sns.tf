resource "aws_sns_topic" "ec2_app_stop_alert" {
  name = "ec2-quote-app-stop-alert"

  tags = var.default_tags
}

resource "aws_sns_topic_subscription" "sqs_subscription" {
  topic_arn = aws_sns_topic.ec2_app_stop_alert.arn
  protocol  = "email"
  endpoint  = var.notification_email
}
