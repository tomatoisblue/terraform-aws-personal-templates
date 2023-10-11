provider "aws" {
  region  = "ap-southeast-1"
}


data "aws_availability_zones" "az_singapore" {
  state = "available"
}

module "default" {
  source = "../module/"
  region = "ap-southeast-1"
  availability_zones = [data.aws_availability_zones.az_singapore.names[0], data.aws_availability_zones.az_singapore.names[1]]
  prefix = "singapore"
  ami = "ami-0d6bc09aca9040ef4"
}

resource "aws_key_pair" "example" {
  key_name   = "my-key"
  public_key = file("id_rsa.pub")
}