variable "aws_region" {
  description = "The AWS region to deploy resources, in this module the jenkins agent if needed"
  type        = string
}

variable "aws_availability_zone" {
  description = "The availability zone to deploy resources"
  type        = string
}

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
  description = "The private subnet to deploy the Jenkins master"
  type        = string
}

variable "public_subnet_id" {
  description = "The public subnet to deploy the Jenkins Load Balancer"
  type        = string
}

variable "other_public_subnet_id" {
  description = "The other public subnet as required by the Application Load Balancer"
  type        = string
}

variable "ssh_pubkey_path" {
  description = "The path to the public key used for Jenkins SSH access"
  type        = string
}

variable "admin_password" {
  description = "The password for the Jenkins admin user"
  type        = string
  default     = "admin123"
}

variable "efs_dns_name" {
  description = "The DNS name of the EFS file system to mount Jenkins Home"
  type        = string
}

variable "sonarqube_url" {
  description = "The URL of the SonarQube server"
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