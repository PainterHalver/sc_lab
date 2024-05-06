variable "default_tags" {
  description = "The default tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "The VPC ID needed for ALB target group"
  type        = string
}

variable "private_subnet_id" {
  description = "The private subnet to deploy the SonarQube"
  type        = string
}

variable "public_subnet_id" {
  description = "The public subnet to deploy the SonarQube Load Balancer"
  type        = string
}

variable "other_public_subnet_id" {
  description = "The other public subnet as required by the Application Load Balancer"
  type        = string
}

variable "ssh_pubkey_path" {
  description = "The path to the public key used for SSH access"
  type        = string
}

variable "efs_dns_name" {
  description = "The DNS name of the EFS file system to mount SonarQube data"
  type        = string
}

variable "route53_zone_id" {
  description = "The Route 53 zone ID to create the DNS record for the SonarQube"
  type        = string
}

variable "route53_zone_name" {
  description = "The Route 53 zone name to create the DNS record for the SonarQube"
  type        = string
}