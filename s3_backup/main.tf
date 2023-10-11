terraform {
  required_version = ">=0.11.0"
  backend "s3"  {
    bucket  = "terraform-20220128023913128200000001"
    region  = "ap-northeast-1"
    key     = "terraform.tfstate"
    encrypt = true
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

resource "aws_s3_bucket" "terraform_state" {
  # bucket = "example-terraform-state"
  acl      = "private"

  server_side_encryption_configuration{
    rule{
        apply_server_side_encryption_by_default{
          sse_algorithm = "AES256"
        }
    }
  }

  versioning {
    enabled = true
  }
}