variable "vpc_cidr" {}

variable "prefix_name" {}

variable "name" {}

variable "key_name" {}

variable "region" {}

variable "availability_zone" {
  default = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
}

variable "base_ami" {}

variable "app_instance_type" {}

variable "db_instance_type" {}

variable "app_version" {}
