module "default" {
  source      = "./module"
  prefix      = "test"
  key_name    = "test-key"
  bucket_name = "test-247823749235"

  # ec2_count = 2
}