provider "aws" {
  region  = "ap-northeast-1"
}

data "aws_availability_zones" "az_tokyo" {
  state = "available"
}

module "default" {
  source = "../module/"
  region = "ap-northeast-1"
  availability_zones = [data.aws_availability_zones.az_tokyo.names[0], data.aws_availability_zones.az_tokyo.names[1]]
  prefix = "tokyo"
  ami = "ami-04e13472d66d065c9"
}