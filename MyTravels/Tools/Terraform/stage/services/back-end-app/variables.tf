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
}

variable "db_password" {
 description = "The password for the database"
 type = string
}