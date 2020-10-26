# Create a vpc endpoint for ssm in the private app network
resource "aws_security_group" "ssm_sg" {
  name        = "ssm-sg"
  description = "Allow TLS inbound To AWS Systems Manager Session Manager"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "HTTPS from app subnet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = module.vpc.private_subnets_cidr_blocks
  }

  egress {
    description = "Allow All Egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Terraform   = "true"
    Project     = "${var.project_name}"
    Environment = "${var.environment}"
  }
}

resource "aws_vpc_endpoint" "ssm" {
  vpc_id            = module.vpc.vpc_id
  subnet_ids        = [module.vpc.private_subnets[0]]
  service_name      = "com.amazonaws.${data.aws_region.current.name}.ssm"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    "${aws_security_group.ssm_sg.id}",
  ]

  private_dns_enabled = true

  tags = {
    Name        = "${var.project_name}-${var.environment}-ssm_vpce"
    Terraform   = "true"
    Project     = "${var.project_name}"
    Environment = "${var.environment}"
  }

}

resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id            = module.vpc.vpc_id
  subnet_ids        = [module.vpc.private_subnets[0]]
  service_name      = "com.amazonaws.${data.aws_region.current.name}.ec2messages"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    "${aws_security_group.ssm_sg.id}",
  ]

  private_dns_enabled = true

  tags = {
    Name        = "${var.project_name}-${var.environment}-ec2messages_vpce"
    Terraform   = "true"
    Project     = "${var.project_name}"
    Environment = "${var.environment}"
  }
}

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id            = module.vpc.vpc_id
  subnet_ids        = [module.vpc.private_subnets[0]]
  service_name      = "com.amazonaws.${data.aws_region.current.name}.ssmmessages"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    "${aws_security_group.ssm_sg.id}",
  ]

  private_dns_enabled = true

  tags = {
    Name        = "${var.project_name}-${var.environment}-ssmmessages_vpce"
    Terraform   = "true"
    Project     = "${var.project_name}"
    Environment = "${var.environment}"
  }
}


# Create EC2 Instance Role
resource "aws_iam_role" "ssm_role" {
  name = "${var.project_name}-${var.environment}-ssm-role"
  path = "/"
  tags = {
    Name        = "${var.project_name}-${var.environment}-ssm-role",
    Terraform   = "true"
    Project     = "${var.project_name}"
    Environment = "${var.environment}"
  }

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

data "aws_iam_policy" "AmazonSSMManagedInstanceCore" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "ssm-role-policy-attach" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = data.aws_iam_policy.AmazonSSMManagedInstanceCore.arn
}

resource "aws_iam_instance_profile" "ssm_profile" {
  name = "ssm_profile"
  role = aws_iam_role.ssm_role.name
}
