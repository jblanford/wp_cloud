provider "aws" {
  region      = "us-east-2"
  profile     = "terraform"
}

# lookup the current region
data "aws_region" "current" {}
