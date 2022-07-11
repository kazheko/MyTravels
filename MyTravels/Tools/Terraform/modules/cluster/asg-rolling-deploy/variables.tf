variable "env_name" {
  description = "The name to use for all the environment resources"
  type = string
}

variable "enable_autoscaling" {
 description = "If set to true, enable auto scaling"
 type = bool
}

variable "target_group_arns" {
  description = "The ARNs of ELB target groups in which to register Instances"
  type        = list(string)
}

variable "subnet_ids" {
  description = "The subnet IDs to deploy to"
  type        = list(string)
}

# === OPTIONAL ===

variable "health_check_type" {
  description = "The type of health check to perform. Must be one of: EC2, ELB."
  type        = string
  default     = "EC2"
}

variable "user_data" {
  description = "The User Data script to run in each Instance at boot"
  type        = string
  default     = null
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type = number
  default = 8080
}