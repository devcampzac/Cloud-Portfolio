# ACM certificate (multi-domain)
resource "aws_acm_certificate" "cert" {
  domain_name               = var.domain_name
  subject_alternative_names = [var.SAN]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}