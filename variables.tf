variable "project_name" {
  type = string
}

variable "credential" {
  type = string
}

variable "region" {
  type    = string
  default = "asia-southeast1"
}

variable "zone" {
  type    = string
  default = "asia-southeast1-a"
}

locals {
  prefix = "terraform"
}
