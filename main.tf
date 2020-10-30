provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

# lookup the current region
data "aws_region" "current" {}

# lookup latest amazon linux 2 ami
data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}
