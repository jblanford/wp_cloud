resource "aws_efs_file_system" "efs-exports" {
  performance_mode = "generalPurpose"
  throughput_mode = "bursting"
  encrypted = "false"

  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-exports"
    Project     = "${var.project_name}"
    Terraform   = "true"
    Environment = "${var.environment}"
  }
}

# efs mount points (one per data subnet)
resource "aws_efs_mount_target" "efs-mnt-exports" {
  count = length(module.vpc.database_subnets)

  file_system_id  = aws_efs_file_system.efs-exports.id
  subnet_id       = module.vpc.database_subnets[count.index]
  security_groups = [aws_security_group.efs-exports.id]
}

# sg for the efs mount points
resource "aws_security_group" "efs-exports" {
  name        = "${var.project_name}-efs-mount-points-sg"
  description = "Security group efs mount points"
  vpc_id      =  module.vpc.vpc_id

  tags = {
    Name = "${var.project_name}-efs-mount-points-sg",
    Terraform   = "true"
    Project     = "${var.project_name}"
    Environment = "${var.environment}"
  }
}

# Allow nfsv4 in from public-web_server-sg
resource "aws_security_group_rule" "efs-exports-nfsv4-in" {
  type                     = "ingress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.public-web_server.id #allow from this sg
  security_group_id        = aws_security_group.efs-exports.id # attach to this sg
}

# Allow all out from efs-exports to public-web_server-sg
resource "aws_security_group_rule" "efs-exports-all-out" {
  type                     = "egress"
  from_port                = -1
  to_port                  = -1
  protocol                 = "-1"
  source_security_group_id = aws_security_group.public-web_server.id #allow out to this sg
  security_group_id        = aws_security_group.efs-exports.id # attach to this sg
}
