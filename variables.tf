variable "project_name" {
  description = "The name of this project"
  type        = string
  default     = "my_project"
}

variable "environment" {
  description = "Environment name for this deployment"
  type        = string
  default     = "dev"
}

variable "web_server_ami" {
  description = "Ami to use for the web servers"
  type        = string
}

variable "web_server_instance_type" {
  description = "EC2 instance type to use for the web servers"
  type        = string
  default     = "t2.micro"
}

variable "web_server_key_name" {
  description = "IAM key to install on web servers"
  type        = string
}

variable "db_main_id" {
  description = "RDS main db identifier"
  type        = string
}

variable "db_replica_id" {
  description = "RDS replica db identifier"
  type        = string
}

variable "db_user" {
  description = "RDS db user"
  type        = string
}

variable "db_pass" {
  description = "RDS db user password"
  type        = string
}

variable "rds_main_enabled" {
  description = "Create main database"
  type        = bool
  default     = false
}

variable "rds_replica_enabled" {
  description = "Create replica database"
  type        = bool
  default     = false
}

variable "dns_zone" {
  description = "Route53 hosted dns zone for project"
  type        = string
}
