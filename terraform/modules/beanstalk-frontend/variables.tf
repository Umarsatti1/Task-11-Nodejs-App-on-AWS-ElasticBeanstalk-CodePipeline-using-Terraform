# Input Variables
variable "frontend_application_name" {
    type = string
}

variable "frontend_environment_name" {
    type = string
}

variable "frontend_platform" {
    type = string
}

# Reference Variables
variable "vpc_id" {
    type = string
}

variable "public_subnets" {
    type = list(string)
}

variable "eb_service_role" {
    type = string
}

variable "ec2_instance_profile" {
    type = string
}

variable "backend_api_url" {
    type = string
}