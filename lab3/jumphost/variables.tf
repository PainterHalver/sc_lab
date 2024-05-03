variable "instance_type" {
  description = "The instance type to use for the Jumphost"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID to deploy the Jumphost"
  type        = string
}

variable "subnet_id" {
  description = "The subnet ID to deploy the Jumphost"
  type        = string
}

variable "ssh_pubkey_path" {
  description = "The path to the SSH public key to use for the Jumphost"
  type        = string
}

variable "default_tags" {
  description = "The default tags to apply to resources"
  type        = map(string)
}

variable "efs_dns_name" {
  description = "The DNS name of the EFS filesystem to mount home dir"
  type        = string
}
