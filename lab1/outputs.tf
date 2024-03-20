output "ec2_app_public_ip" {
  value = aws_instance.ec2_app.public_ip
}

output "ec2_ldap_public_ip" {
  value = aws_instance.ec2_ldap.public_ip
}
