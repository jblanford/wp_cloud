provider "aws" {
  region  = "us-east-2"
  profile = "terraform"
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
