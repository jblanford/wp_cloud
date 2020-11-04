
module "main" {
  source  = "terraform-aws-modules/rds/aws"
  version = "2.18.0"

  count = var.rds_main_enabled ? 1 : 0

  identifier = "${var.db_main_id}"

  engine            = "mariadb"
  engine_version    = "10.3"
  instance_class    = "db.t3.micro"
  allocated_storage = 20

  name     = "${var.project_name}_${var.environment}_main"
  username = "${var.db_user}"
  password = "${var.db_pass}"
  port     = "3306"

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  vpc_security_group_ids = [aws_security_group.rds_servers.id]

  multi_az = true

  # DB subnet group
  subnet_ids = module.vpc.database_subnets

  # DB parameter group
  family = "mariadb10.3"

  # DB option group
  major_engine_version = "10.3"

  tags = {
    Project     = "${var.project_name}"
    Terraform   = "true"
    Environment = "${var.environment}"
  }

}

module "replica" {
  source  = "terraform-aws-modules/rds/aws"
  version = "2.18.0"

  count = var.rds_replica_enabled ? 1 : 0

  identifier = "${var.db_replica_id}"

  # Source database.
  #replicate_source_db = module.main.this_db_instance_id

  engine            = "mariadb"
  engine_version    = "10.3"
  instance_class    = "db.t3.micro"
  allocated_storage = 20

  name = "${var.project_name}_${var.environment}_replica"

  # Username and password should not be set for replicas
  username = ""
  password = ""
  port     = "3306"

  maintenance_window = "Tue:00:00-Tue:03:00"
  backup_window      = "03:00-06:00"

  vpc_security_group_ids = [aws_security_group.rds_servers.id]

  multi_az = true

  # disable backups to create DB faster
  backup_retention_period = 0

  # DB parameter group
  family = "mariadb10.3"

  # DB option group
  major_engine_version = "10.3"

  # Not allowed to specify a subnet group for replicas in the same region
  create_db_subnet_group = false

  create_db_option_group    = false
  create_db_parameter_group = false

  tags = {
    Project     = "${var.project_name}"
    Terraform   = "true"
    Environment = "${var.environment}"
  }

}
