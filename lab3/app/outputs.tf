output "rds" {
  value = {
    address  = aws_db_instance.app.address
    endpoint = aws_db_instance.app.endpoint
  }
}

output "app_alb_dns_name" {
  value = aws_lb.app.dns_name
}