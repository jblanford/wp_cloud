# Create EC2 Instance Role
resource "aws_iam_role" "ssm_role" {
  name             = "${var.project_name}-${var.environment}-ssm-role"
  path             = "/"
  tags = {
    Name = "${var.project_name}-${var.environment}-ssm-role",
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
  name       = "ssm_profile"
  role       = aws_iam_role.ssm_role.name
}
