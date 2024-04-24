output "nat_public_ip" {
  value = module.vpc.nat_public_ip
}

# output "jenkins_alb_dns_name" {
#   value = module.jenkins.jenkins_alb_dns_name
# }

output "rds" {
  value = module.app.rds
}

output "app_alb_dns_name" {
  value = module.app.app_alb_dns_name
}
