resource "aws_s3_bucket" "demo" {
    bucket = "my-demo-bucket-1234535354" # Replace with your desired bucket name

    tags = {
        Name        = "my-demo-bucket-1234535354"
        Environment = "Dev" #optional: you can change
}
}

module "my_bucket" {
  source      = "./modules/bucket"
  bucket_name = "my-demo-bucket-535234234" # Replace with your desired bucket name
}

resource "aws_iam_policy" "s3_read_access" {
  name        = "s3-read-access"
  description = "Policy to allow read access to the S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["s3:GetObject"]
        Effect   = "Allow"
        Resource = "${module.my_bucket.bucket_arn}/*"
      }
    ]
  })
}