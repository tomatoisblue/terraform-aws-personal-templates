variable "instance_type" {
  default = "t2.nano"
}

variable "region" {
  default = "ap-northeast-1"
}

variable "prefix" {
  default = "default"
}

variable "key_name" {
  default = "my-key"
}

variable "bucket_name" {
  default = "test-bucket-28374892647"
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