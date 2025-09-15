resource "aws_cloudfront_origin_access_control" "primary_oac" {
  name                              = "primary-website-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_response_headers_policy" "security_headers" {
  name = "security-headers"

  security_headers_config {
    content_security_policy {
      content_security_policy = "default-src 'self'; img-src * data:; style-src 'self'; script-src 'self'; connect-src 'self' ${var.apigateway};"
      override                = true
    }
    content_type_options { override = true }
    frame_options {
      frame_option = "DENY"
      override     = true
    }
    referrer_policy {
      referrer_policy = "no-referrer-when-downgrade"
      override        = true
    }
    strict_transport_security {
      access_control_max_age_sec = 63072000
      include_subdomains         = true
      preload                    = true
      override                   = true
    }
    xss_protection {
      protection = true
      mode_block = true
      override   = true
    }
  }
}


# Main CloudFront distribution (serves site)
resource "aws_cloudfront_distribution" "website_bucket_cdn" {
  enabled             = true
  is_ipv6_enabled     = true
  aliases             = [var.domain_name]
  default_root_object = "index.html"

  origin {
    domain_name              = aws_s3_bucket.website_bucket.bucket_regional_domain_name
    origin_id                = "primary-s3-origin"
    origin_access_control_id = aws_cloudfront_origin_access_control.primary_oac.id
  }

  default_cache_behavior {
    target_origin_id       = "primary-s3-origin"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    response_headers_policy_id = null

    forwarded_values {
      query_string = false
      cookies { forward = "none" }
    }
  }

  restrictions {
    geo_restriction { restriction_type = "none" }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.cert.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2019"
  }
  
  logging_config {
    bucket = aws_s3_bucket.cf_logs.bucket_domain_name
    include_cookies = false
    prefix          = "cf-logs/"
}
}


# Secondary CloudFront distribution (redirects www → root)
resource "aws_cloudfront_distribution" "www_redirect" {
  enabled         = true
  is_ipv6_enabled = true

  aliases = [var.SAN]

  origin {
    domain_name = var.domain_name # Redirect target
    origin_id   = "redirect-to-root"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    target_origin_id       = "redirect-to-root"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    #CloudFront function for redirect
    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.www_redirect.arn
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.cert.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2019"
  }

    depends_on = [
    aws_acm_certificate.cert
  ]
}

# CloudFront Function to handle redirect
resource "aws_cloudfront_function" "www_redirect" {
  name    = "www-to-root-redirect"
  runtime = "cloudfront-js-1.0"
  code    = <<EOT
function handler(event) {
  var request = event.request;
  var response = {
    statusCode: 301,
    statusDescription: 'Moved Permanently',
    headers: {
      'location': { value: ${var.url} }
    }
  };
  return response;
}
EOT
}
