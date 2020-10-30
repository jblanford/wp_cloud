## Project VPC
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.55.0"

  name = "${var.project_name}-${var.environment}"

  cidr = var.vpc_cidr

  azs              = var.vpc_azs
  public_subnets   = var.vpc_public_subnets
  private_subnets  = var.vpc_private_subnets
  database_subnets = var.vpc_database_subnets

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
