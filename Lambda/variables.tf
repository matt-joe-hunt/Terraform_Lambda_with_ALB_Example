variable "region-master" {
  type    = string
}

variable "environment" {
  type    = string
}

variable "project" {
  type    = string
}

variable "runtime" {
  type    = string
  default = "nodejs12.x"
}

variable "accountId" {
  type    = string
}

variable "aws_lb_target_group_arn" {
  type = string
  description = "(optional) describe your variable"
}