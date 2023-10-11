# Create a empty folder called "wsl2".
# Do not add 'source' attribute to create a empty folder.

resource "aws_s3_bucket_object" "wsl2_object" {
  bucket =  aws_s3_bucket.my_bucket.id

  # key attribute is gonna be the folder name
  key = "wsl2"

  # source = "..."
}


