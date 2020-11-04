# sg for rds servers
resource "aws_security_group" "rds_servers" {
  name        = "${var.project_name}-rds_servers-sg"
  description = "Security group for rds servers"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name        = "${var.project_name}-rds-sg",
    Terraform   = "true"
    Project     = "${var.project_name}"
    Environment = "${var.environment}"
  }
}

# Allow mysql in from web_server-sg
resource "aws_security_group_rule" "rds_servers-mysql-in" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.web_server.id  #allow from this sg
  security_group_id        = aws_security_group.rds_servers.id # attach to this sg
}

# Allow all out from rds_servers to web_server-sg
resource "aws_security_group_rule" "rds_servers-all-out" {
  type                     = "egress"
  from_port                = -1
  to_port                  = -1
  protocol                 = "-1"
  source_security_group_id = aws_security_group.web_server.id  #allow out to this sg
  security_group_id        = aws_security_group.rds_servers.id # attach to this sg
}
