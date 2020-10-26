module "ec2_cluster" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 2.0"

  name           = "${var.project_name}-${var.environment}"
  instance_count = 3

  ami                    = "${var.web_server_ami}"
  instance_type          = "${var.web_server_instance_type}"
  key_name               = "${var.web_server_key_name}"
  iam_instance_profile   = aws_iam_instance_profile.ssm_profile.name
  monitoring             = true
  vpc_security_group_ids = [aws_security_group.web_server.id]
  subnet_ids             = module.vpc.private_subnets

  tags = {
    Project     = "${var.project_name}"
    Terraform   = "true"
    Environment = "${var.environment}"
  }
}

# sg for public web servers
resource "aws_security_group" "web_server" {
  name        = "${var.project_name}-web_server-sg"
  description = "Security group for public web servers"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name        = "${var.project_name}-web_server-sg",
    Terraform   = "true"
    Project     = "${var.project_name}"
    Environment = "${var.environment}"
  }
}

# Allow http in from everywhere
resource "aws_security_group_rule" "web_server-http-in" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web_server.id
}

# Allow https in from everywhere
resource "aws_security_group_rule" "web_server-https-in" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web_server.id
}

# Allow ssh in from everywhere
resource "aws_security_group_rule" "web_server-ssh-in" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web_server.id
}

# Allow all trafic out to everywhere
resource "aws_security_group_rule" "web_server-all-out" {
  type              = "egress"
  from_port         = "-1"
  to_port           = "-1"
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web_server.id
}
