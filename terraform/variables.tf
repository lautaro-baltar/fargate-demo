variable "environment" {
  description = "Environment of this project"
  type = string
}

variable "vpc_id" {
    description = "ID of the desired VPC"
    type = string  
}

variable "subnet_ids" {
    description = "IDs of the desired Subnets"
    type = list(string)
}

variable "backend_image" {
  description = "ECR Image to use for the backend container"
  type = string
}

variable "backend_secret" {
  description = "Secret to use for the backend container"
  type = string
}

variable "backend_desired_count" {
  description = "Desired amount of Backend tasks for the service"
  type = number
  default = 1
}

variable "backend_scaling_target" {
    description = "Amount of Request Per Target to trigger scaling"
    type = number
    default = 50
}