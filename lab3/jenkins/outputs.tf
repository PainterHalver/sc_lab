output "jenkins_alb_dns_name" {
  value = aws_lb.jenkins.dns_name
}

output "jenkins_private_ip" {
  value = aws_instance.jenkins.private_ip
}
