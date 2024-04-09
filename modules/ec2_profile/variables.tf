variable "aws_region" {
  type = string
}

variable "default_tags" {
  type     = map(string)
  nullable = true
  default  = {}
}

variable "profile_name" {
  type        = string
  description = "The name of the instance profile"
}

variable "role_name" {
  type        = string
  description = "The name of the IAM role"
}

variable "role_description" {
  type        = string
  description = "The description of the IAM role"
}

variable "inline_policies" {
  type = list(object({
    name     = string
    action   = list(string)
    effect   = string
    resource = string
  }))
  default = []

  validation {
    condition     = alltrue([for policy in var.inline_policies : contains(["Allow", "Deny"], policy.effect)])
    error_message = "Effect must be either 'Allow' or 'Deny'"
  }
}

variable "managed_policy_arns" {
  type    = list(string)
  default = []
}
