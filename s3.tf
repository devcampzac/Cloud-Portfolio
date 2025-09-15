resource "random_string" "random" {
  length = 6
  special = false
  upper = false
} 

resource "aws_s3_bucket" "website_bucket" {
    bucket = "${var.bucketname}-${random_string.random.result}"

    force_destroy = true
    tags = {
    Project     = var.project_name
    Environment = var.Environment
    Owner = var.Owner}
}
resource "aws_s3_bucket_website_configuration" "website_config" {
    bucket = aws_s3_bucket.website_bucket.id

    index_document {
        suffix = "index.html"
    }

    error_document {
        key = "error.html"
    }
}

resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
    bucket = aws_s3_bucket.website_bucket.id
    rule {
        object_ownership = "BucketOwnerPreferred"
    }
}

resource "aws_s3_bucket_policy" "website_bucket_policy" {
  bucket = aws_s3_bucket.website_bucket.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Sid      = "AllowCloudFrontPrimaryRead",
      Effect   = "Allow",
      Principal = { Service = "cloudfront.amazonaws.com" },
      Action   = "s3:GetObject",
      Resource = "${aws_s3_bucket.website_bucket.arn}/*",
      Condition = {
        StringEquals = {
          "AWS:SourceArn" : "${aws_cloudfront_distribution.website_bucket_cdn.arn}"
        }
      }
    }]
  })
}


# Upload index.html
resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.website_bucket.id
  key          = "index.html"
  source       = "${path.module}/website_bucket-site/index.html"
  content_type = "text/html"
  etag         = filemd5("${path.module}/website_bucket-site/index.html")
}

# Upload error.html
resource "aws_s3_object" "error" {
  bucket       = aws_s3_bucket.website_bucket.id
  key          = "error.html"
  source       = "${path.module}/website_bucket-site/error.html"
  content_type = "text/html"
  etag         = filemd5("${path.module}/website_bucket-site/error.html")
}

# Upload CSS
resource "aws_s3_object" "styles" {
  bucket       = aws_s3_bucket.website_bucket.id
  key          = "css/styles-v2.css"
  source       = "${path.module}/website_bucket-site/css/styles-v2.css"
  content_type = "text/css"
  etag         = filemd5("${path.module}/website_bucket-site/css/styles-v2.css")
}

# Upload JS
resource "aws_s3_object" "script" {
  bucket       = aws_s3_bucket.website_bucket.id
  key          = "js/script.js"
  source       = "${path.module}/website_bucket-site/js/script.js"
  content_type = "application/javascript"
  etag         = filemd5("${path.module}/website_bucket-site/js/script.js")
}
resource "aws_s3_object" "counters" {
  bucket       = aws_s3_bucket.website_bucket.id
  key          = "js/counters.js"
  source       = "${path.module}/website_bucket-site/js/counters.js"
  content_type = "application/javascript"
  etag         = filemd5("${path.module}/website_bucket-site/js/counters.js")
}
resource "aws_s3_object" "contact" {
  bucket       = aws_s3_bucket.website_bucket.id
  key          = "js/contact.js"
  source       = "${path.module}/website_bucket-site/js/contact.js"
  content_type = "application/javascript"
  etag         = filemd5("${path.module}/website_bucket-site/js/contact.js")
}

#Upload Favicon
resource "aws_s3_object" "favicon" {
  bucket       = aws_s3_bucket.website_bucket.bucket
  key          = "favicon.ico"
  source       = "${path.module}/favicon.ico"
  content_type = "image/x-icon"
}
