## Project VPC
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.55.0"

  name = "${var.project_name}-${var.environment}"

  cidr = "10.5.0.0/16"

  azs              = ["us-east-2a", "us-east-2b", "us-east-2c"]
  public_subnets   = ["10.5.1.0/24", "10.5.2.0/24", "10.5.3.0/24"]
  private_subnets  = ["10.5.101.0/24", "10.5.102.0/24", "10.5.103.0/24"]
  database_subnets = ["10.5.201.0/24", "10.5.202.0/24", "10.5.203.0/24"]

  enable_ipv6 = false

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  # Needed for EFS
  enable_dns_hostnames = true
  enable_dns_support   = true


  # Global tags for all resources
  tags = {
    Project     = "${var.project_name}"
    Environment = "${var.environment}"
    Terraform   = "true"
  }

  # Tags for public subnet
  public_subnet_tags = {
    Name = "${var.project_name}-${var.environment}-public"
  }

  # Tags for public subnet
  private_subnet_tags = {
    Name = "${var.project_name}-${var.environment}-app"
  }

  # Tags for database subnet
  database_subnet_tags = {
    Name = "${var.project_name}-${var.environment}-data"
  }

  vpc_tags = {
    Name = "vpc-${var.project_name}-${var.environment}"
  }
}
