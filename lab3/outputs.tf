output "ec2_jenkins_public_ip" {
  value = aws_instance.ec2_jenkins.public_ip
}
