output "ec2_nat_public_ip" {
  value = module.vpc_with_nat_instance.nat_public_ip
}

output "ec2_app_private_ip" {
  value = aws_instance.ec2_app.private_ip
}

output "ec2_proxy_private_ip" {
  value = aws_instance.ec2_proxy.private_ip
}
