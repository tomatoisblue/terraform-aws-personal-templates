resource "aws_s3_bucket" "default" {
  bucket        = var.bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_acl" "default" {
  bucket = aws_s3_bucket.default.id
  acl    = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.default.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Upload an objects
resource "aws_s3_object" "default" {
  for_each = fileset("./html/", "*")
  bucket   = aws_s3_bucket.default.id
  key      = each.value
  source   = "./html/${each.value}"
  etag     = filemd5("./html/${each.value}")
}