resource "aws_s3_bucket" "cf_logs" {
  bucket = "${var.bucketname}-cf-logs"
}

# Explicit ownership controls
resource "aws_s3_bucket_ownership_controls" "cf_logs" {
  bucket = aws_s3_bucket.cf_logs.id

  rule {
    object_ownership = "ObjectWriter"
  }
}

# Required for CloudFront logging
resource "aws_s3_bucket_acl" "cf_logs" {
  depends_on = [aws_s3_bucket_ownership_controls.cf_logs]

  bucket = aws_s3_bucket.cf_logs.id
  acl    = "log-delivery-write"
}
