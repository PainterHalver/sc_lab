resource "aws_route53_record" "sonarqube" {
  zone_id = var.route53_zone_id
  name = "sonarqube.${var.route53_zone_name}"
  type = "A"
  ttl = "60"

  records = [ aws_instance.sonarqube.private_ip ]
}