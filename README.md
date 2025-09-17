# Personal Portfolio Website (AWS Serverless)

This project is a personal portfolio website hosted on AWS S3 + CloudFront, with serverless integrations for a site visit counter and a contact form (no public email address required).

# Features

Modern static site with dark mode styling

Hosted on S3 with CloudFront CDN for global performance

HTTPS enabled via ACM certificate

Visit Counter powered by API Gateway, Lambda, and DynamoDB

Contact Form that sends messages via SES (no email exposed)

Infrastructure fully managed with Terraform

Terraform Variable File for easy plug-and-play using your values.

# Deployment
Prerequisites

AWS account with programmatic access

Terraform >= 1.5

AWS CLI configured (aws configure)

A registered domain name (managed in Route 53 or external DNS pointing to CloudFront)

Manual AWS SES Configuration currently required

Your own HTML website files! Mine are included to give an idea or starting point and to show the required folder hierarchy

# Security

OAC (Origin Access Control) ensures CloudFront is the only service that can read from S3.

Public Access Blocked on S3 bucket.

No inline scripts: all JS externalized to avoid CSP violations.

Contact form prevents exposing personal email directly.

# Future Enhancements

Add project portfolio gallery

Integrate CI/CD pipeline with GitHub Actions

Add spam filtering / CAPTCHA for contact form

Configure IaC for AWS SES for contact form

# License

MIT License. Free to use and adapt.
