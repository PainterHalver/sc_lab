output "ec2_jenkins_public_ip" {
  value = aws_instance.ec2_jenkins.public_ip
}

# output "ec2_nat_public_ip" {
#   value = module.vpc_with_nat_instance.nat_public_ip
# }
