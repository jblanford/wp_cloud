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

variable "public_servers_count" {
  description = "Number of public servers"
  type        = number
  default     = 3
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

variable "asg_desired_capacity" {
  description = "Desired number of servers in the asg"
  type        = number
  default     = 3
}

variable "asg_min_size" {
  description = "Minimum number of servers in the asg"
  type        = number
  default     = 1
}

variable "asg_max_size" {
  description = "Maximum number of servers in the asg"
  type        = number
  default     = 9
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

variable "aurora_serverless_enabled" {
  description = "Create aurora serverless db"
  type        = bool
  default     = false
}

variable "aurora_serverless_min" {
  description = "Minimum compute capacity"
  type        = number
  default     = 1
}

variable "aurora_serverless_max" {
  description = "Maximum compute capacity"
  type        = number
  default     = 4
}

variable "aurora_serverless_timeout" {
  description = "Seconds unti auto pause"
  type        = number
  default     = 300
}

variable "dns_zone" {
  description = "Route53 hosted dns zone for project"
  type        = string
}
