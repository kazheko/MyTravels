variable "db_username" {
 description = "The username for the database"
 type = string
 default = "postgres"
}

variable "db_name" {
 description = "The database name"
 type = string
 default = "mytravels"
}

variable "env_name" {
  description = "The name to use for all the environment resources"
  type = string
}
