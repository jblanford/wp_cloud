resource "aws_lb" "web-alb" {
  name               = "${var.project_name}-${var.environment}-web-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = module.vpc.public_subnets

  enable_deletion_protection = true

  tags = {
      Project     = "${var.project_name}"
      Terraform   = "true"
      Environment = "${var.environment}"
    }
}

output "alb_dns_name" {
  value       = aws_lb.web-alb.dns_name
  description = "The domain name of the load balancer"
}

# For alb allow port 80 in from anywhere and out to anywhere
resource "aws_security_group" "alb" {

  name    = "${var.project_name}-${var.environment}-alb-sg"
  vpc_id  =  module.vpc.vpc_id
  description = "Security group for the web alb"

  # Allow inbound HTTP requests
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound requests
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-alb-sg",
    Terraform   = "true"
    Project     = "${var.project_name}"
    Environment = "${var.environment}"
  }
}

resource "aws_lb_target_group" "web-80-tg" {

  name = "${var.project_name}-${var.environment}-web-80-tg"

  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-web-80-tg",
    Terraform   = "true"
    Project     = "${var.project_name}"
    Environment = "${var.environment}"
  }
}

resource "aws_lb_listener" "web-80" {
  load_balancer_arn = aws_lb.web-alb.arn
  port              = 80
  protocol          = "HTTP"

  # By default, return a simple 404 page
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web-80-tg.arn
  }
}
