module "ec2_cluster" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 2.0"

  name           = "${var.project_name}-${var.environment}"
  instance_count = var.public_servers_count

  ami                    = "${var.web_server_ami}"
  instance_type          = "${var.web_server_instance_type}"
  key_name               = "${var.web_server_key_name}"
  iam_instance_profile   = aws_iam_instance_profile.ssm_profile.name
  monitoring             = true
  vpc_security_group_ids = [aws_security_group.web_server.id]
  subnet_ids             = module.vpc.public_subnets

  tags = {
    Project     = "${var.project_name}"
    Terraform   = "true"
    Environment = "${var.environment}"
  }
}
