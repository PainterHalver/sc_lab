output "sonarqube_alb_dns_name" {
  value = aws_lb.sonarqube.dns_name
}

output "sonarqube_private_ip" {
  value = aws_instance.sonarqube.private_ip
}

output "url" {
  value = "http://${aws_instance.sonarqube.private_ip}:9000"
}
