variable "aws_region" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "public_subnet_cidr" {
  type = string
}

variable "private_subnet_cidr" {
  type = string
}

variable "subnet_az" {
  type = string
}

variable "default_tags" {
  type     = map(string)
  nullable = true
  default  = {}
}

variable "with_nat_instance" {
  type = object({
    enabled = bool
    ssh_pubkey_path = string
  })
  default = {
    enabled = false
    ssh_pubkey_path = null
  }
}
