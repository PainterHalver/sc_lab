output "ec2_app_public_ip" {
  value = aws_instance.ec2_app.public_ip
}

output "ec2_ldap_private_ip" {
  value = aws_instance.ec2_ldap.private_ip
}

output "ec2_nat_public_ip" {
  value = module.vpc_ldap.nat_public_ip
}

output "clb_dns_name" {
  value = aws_elb.ldap_clb.dns_name
}

# output "nlb_dns_name" {
#   value = aws_lb.ldap_nlb.dns_name
# }
