resource "aws_route53_record" "jenkins" {
  zone_id = var.route53_zone_id
  name = "jenkins.${var.route53_zone_name}"
  type = "A"
  ttl = "60"

  records = [ aws_instance.jenkins.private_ip ]
}