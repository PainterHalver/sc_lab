variable "aws_availability_zone" {
  description = "The availability zone to launch the EFS in"
  type        = string
}

variable "default_tags" {
  description = "The default tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "The VPC ID needed for the EFS mount target"
  type        = string
}

variable "subnet_id" {
  description = "The subnet ID to for the EFS mount target"
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR block of the VPC, to restrict EFS security group"
  type        = string
}
