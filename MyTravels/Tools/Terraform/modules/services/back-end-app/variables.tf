variable "env_name" {
  description = "The name to use for all the environment resources"
  type = string
}

variable "enable_autoscaling" {
 description = "If set to true, enable auto scaling"
 type = bool
}

variable "db_password" {
  description = "The password for the database"
  type = string
}

variable "db_remote_state" {
  description = "The config for the database's remote state in S3"
  type = object({
    bucket = string
    key = string
  })
}

# === Optional ===

variable "web_port" {
  description = "The port the server will use for HTTP requests"
  type = number
  default = 8080
}
