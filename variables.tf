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
