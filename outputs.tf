output "main_cloudfront_domain" {
  value = aws_cloudfront_distribution.website_bucket_cdn.domain_name
}

output "www_cloudfront_domain" {
  value = aws_cloudfront_distribution.www_redirect.domain_name
}

output "acm_dns_validation_records" {
  description = "DNS records to validate ACM cert. Add these to your DNS provider."
  value = [
    for dvo in aws_acm_certificate.cert.domain_validation_options : {
      name  = dvo.resource_record_name
      type  = dvo.resource_record_type
      value = dvo.resource_record_value
    }
  ]
}

# Output the API endpoint
output "api_endpoint" {
  value = aws_apigatewayv2_api.http_api.api_endpoint
}

output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.website_bucket_cdn.id
}

