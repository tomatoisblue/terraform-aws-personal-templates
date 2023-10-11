variable "instance_type" {
  default = "t2.nano"
}

variable "region" {
  default = "ap-northeast-1"
}

variable "prefix" {
  default = "elb-test"
}

variable "key_name" {
  default = "my-key"
}

variable "ssh_port_num" {
  default = 22
}

variable "availability_zones" {
  type    = list(string)
  default = ["ap-northeast-1a", "ap-northeast-1c"]
}

variable "availability_zones_suffix" {
  type    = list(string)
  default = ["1a", "1c"]
}

variable "bucket_name" {
  default = "alb-test-2022-02-22"
}

variable "ami" {
  default = "ami-04e13472d66d065c9"
}