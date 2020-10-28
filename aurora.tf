resource "aws_rds_cluster" "aurora" {
  cluster_identifier      = "${var.project_name}-${var.environment}-aurora"
  vpc_security_group_ids  = [aws_security_group.rds_servers.id]
  db_subnet_group_name    = aws_db_subnet_group.aurora.name

  engine_mode             = "serverless"

  backup_retention_period = 7
  skip_final_snapshot     = false

  master_username = var.db_user
  master_password = var.db_pass

  scaling_configuration {
    auto_pause               = true
    max_capacity             = 4
    min_capacity             = 2
    seconds_until_auto_pause = 300
    timeout_action           = "ForceApplyCapacityChange"
  }

  tags = {
    Project     = "${var.project_name}"
    Terraform   = "true"
    Environment = "${var.environment}"
  }
}

resource "aws_db_subnet_group" "aurora" {
  name        = "${var.project_name}-${var.environment}-aurora-subnet"
  description = "Subnet group for aurora serverless"
  subnet_ids  = module.vpc.database_subnets

  tags = {
    Project     = "${var.project_name}"
    Terraform   = "true"
    Environment = "${var.environment}"
  }
}

output "this_rds_cluster_endpoint" {
  description = "The cluster endpoint"
  value       = aws_rds_cluster.aurora.endpoint
}
