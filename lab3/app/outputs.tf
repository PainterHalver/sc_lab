output "ec2_nat_public_ip" {
  value = module.vpc_with_nat_instance.nat_public_ip
}

output "rds" {
  value = {
    address  = aws_db_instance.app_database.address
    endpoint = aws_db_instance.app_database.endpoint
  }
}

output "alb_dns_name" {
  value = aws_lb.app_alb.dns_name
}
