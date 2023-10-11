variable "instance_type" {
  default = "t2.nano"
}

variable "region" {}

variable "prefix" {}

variable "key_name" {
  default = "my-key"
}

variable "ssh_port_num" {
  default = 8637
}

variable "availability_zones" {
  type    = list(string)
}

variable "bucket_name" {
  default = "alb-test-2022-02-22"
}

variable "ami" {}
