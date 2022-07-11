variable "web_port" {
  description = "The port the server will use for HTTP requests"
  type = number
  default = 8080
}

variable "db_database" {
  description = "The name for the database"
  type = string
  default = "mytravels"
}

variable "db_username" {
  description = "The username for the database"
  type = string
  default = "postgres"
}

variable "db_password" {
  description = "The password for the database"
  type = string
}

variable "env_name" {
  description = "The name to use for all the environment resources"
  type = string
}

variable "db_remote_state_bucket" {
  description = "The name of the S3 bucket for the database's remote state"
  type = string
}
variable "db_remote_state_key" {
  description = "The path for the database's remote state in S3"
  type = string
}

variable "enable_autoscaling" {
 description = "If set to true, enable auto scaling"
 type = bool
}
