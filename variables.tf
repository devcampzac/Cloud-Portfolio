variable "project_name" {
  description = "Name prefix for resources"
  type        = string
  default = "My-Website"
}

variable "domain_name" {
  description = "Root domain name for the website"
  type        = string
}

variable "region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "SAN" {
  description = "Redirect WWW SAN"
  type        = string
}

variable "apigateway" {
  description = "API Gateway value for visitor counter"
  type        = string
}
variable "url" {
  description = "Header value for redirect script"
  type = string
}
variable "table_name" {
  description = "DynamoDB Table Name"
  type = string
}
variable "bucketname" {
  description = "S3 bucket name prefix"
  type = string
  default = "my-s3-bucket"
}
variable "Owner" {
  description = "Name of Asset owner"
  type = string
  default = "Me"
}
variable "Environment" {
  description = "Produciton, Sandbox, etc"
  type = string
}
variable "CredProfile" {
    description = "AWS Credential File Profile Value"
    type = string
    default = "default"
}
variable "CredProfileLocation" {
  description = "Location of AWS Credential File"
   type = string
   default = "~/.aws/credentials"
}
variable "Dest_Email" {
  description = "Email for contact form on site"
}