variable "name" {}
variable "vpc_id" {}

variable "lb_cert_arn" {
  default = ""
}

variable "target_group_id" {
  default = ""
}

variable "lb_subnet_ids" {
  type    = "list"
  default = []
}
