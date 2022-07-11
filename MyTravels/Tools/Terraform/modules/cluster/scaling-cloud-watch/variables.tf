variable "env_name" {
  description = "The name to use for all the environment resources"
  type = string
}

variable "enable_autoscaling" {
 description = "If set to true, enable auto scaling"
 type = bool
}

variable "autoscaling_group_name" {
  description = "The name of ASG"
  type        = string
}

