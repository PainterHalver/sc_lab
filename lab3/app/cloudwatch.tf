resource "aws_cloudwatch_dashboard" "ec2_app_dashboard" {
  dashboard_name = "python-app-dashboard"
  dashboard_body = templatefile("${path.module}/resources/cloudwatch_dashboard.json.tftpl", {
    target_group_arn_suffix = aws_lb_target_group.ec2_app_http.arn_suffix,
    alb_arn_suffix          = aws_lb.app.arn_suffix,
    aws_region              = var.aws_region,
    db_identifier           = aws_db_instance.app.identifier,
  })
}
