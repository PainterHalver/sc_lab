variable "aws_region" {
  description = "The AWS region to deploy resources"
  nullable    = false
}

variable "aws_availability_zone" {
  description = "The availability zone to deploy resources"
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
