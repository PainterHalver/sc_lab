variable "aws_region" {
  description = "The AWS region to deploy resources"
  nullable    = false
}

variable "aws_availability_zone" {
  description = "The availability zone to deploy resources"
  nullable    = false
}

variable "aws_availability_zone_2" {
  description = "The AZ to deploy the second private subnet in, this is needed for RDS and should be different from the first AZ"
  nullable    = false
}

variable "instance_type" {
  description = "The general type of instance to launch"
  default     = "t2.micro"
}

variable "ssh_pubkey_path" {
  description = "The path to the public key used for SSH access"
  default     = "~/.ssh/id_rsa.pub"
}

variable "default_tags" {
  description = "The default tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "db_admin_user" {
  description = "The admin user of the RDS instance"
  type        = string
}

variable "db_admin_password" {
  description = "The password of the admin user of the RDS instance"
  type        = string
}

variable "app_git_commit_hash" {
  description = "The hash of the latest git commit, used to update if the ASG launch template"
  type        = string
}
