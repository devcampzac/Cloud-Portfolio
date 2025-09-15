terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
    required_version = ">= 1.3.0"
}

provider "aws" {
    region = var.region
    shared_credentials_files = [var.CredProfileLocation]
    profile = var.CredProfile
    default_tags {
        tags = {
            Project     = var.project_name
            Environment = var.Environment
        }
    }
}