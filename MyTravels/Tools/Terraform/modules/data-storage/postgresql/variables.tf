variable "db_username" {
 description = "The username for the database"
 type = string
 default = "postgres"
}

variable "env_name" {
  description = "The name to use for all the environment resources"
  type = string
}
