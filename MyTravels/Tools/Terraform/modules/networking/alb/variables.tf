variable "env_name" {
  description = "The name to use for all the environment resources"
  type = string
}

variable "subnet_ids" {
  description = "The subnet IDs to deploy to"
  type        = list(string)
}