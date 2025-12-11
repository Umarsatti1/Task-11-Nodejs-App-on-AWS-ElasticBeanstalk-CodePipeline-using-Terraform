# Reference from other modules
variable "vpc_id" {
    type = string
}

variable "private_subnet_ids" {
    type = list(string)
}

variable "private_sg_id" {
    type = string
}

variable "codebuild_service_role" {
    type = string
}

# CodeBuild Variables
variable "codebuild_project_name" {
    type = string
}

variable "account_id" {
    type = string
}

variable "region" {
    type = string
}

variable "codebuild_logs" {
    type = string
}