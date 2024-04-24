variable "aws_availability_zone" {
  description = "The availability zone to launch the resources in"
  type        = string
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

variable "vpc_id" {
  description = "The VPC ID needed for ALB target group"
  type        = string
}

variable "sg_nat_id" {
  description = "The Security Group ID of the NAT instance"
  type        = string
}

variable "public_subnet_id" {
  description = "The main public subnet ID to launch resources"
  type        = string
}

variable "other_public_subnet_id" {
  description = "The other public subnet as required by the Application Load Balancer"
  type        = string
}

variable "private_subnet_id" {
  description = "The main private subnet ID to launch resources"
  type        = string
}

variable "database_subnet_ids" {
  description = "The subnet IDs to deploy the RDS instance in"
  type        = list(string)
}

variable "db_admin_user" {
  description = "The admin user of the RDS instance"
  type        = string
  default     = "admin"
}

variable "app_git_commit_hash" {
  description = "The hash of the latest git commit, used to update if the ASG launch template"
  type        = string
}
