provider "aws" {
  profile = "default"
  region  = var.regions["tokyo"]
}

provider "aws" {
  alias  = "singapore"
  region = var.regions["singapore"]
}

data "aws_availability_zones" "az_tokyo" {
  state = "available"
}

data "aws_availability_zones" "az_singapore" {
  provider = aws.singapore
  state    = "available"
}


module "network-tokyo" {
  source = "./module/"
  cidr   = "10.0.0.0/16"
  name   = "tokyo"
  az     = data.aws_availability_zones.az_tokyo.names[0]
}

module "network-singapore" {
  source = "./module/"
  cidr   = "10.1.0.0/16"
  name   = "singapore"
  az     = data.aws_availability_zones.az_singapore.names[0]
  providers = {
    aws = aws.singapore
  }
}