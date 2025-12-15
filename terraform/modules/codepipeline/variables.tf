# Reference Variables
variable "codebuild_project_arn" {
    type = string
}

variable "codebuild_project_name" {
    type = string
}

variable "codepipeline_service_role" {
    type = string
}

variable "backend_application_name" {
    type = string
}

variable "backend_environment_name" {
    type = string
}

variable "frontend_application_name" {
    type = string
}

variable "frontend_environment_name" {
    type = string
}

# CodePipeline Variables
variable "pipeline_bucket_name" {
    type = string
}

variable "github_connection_arn" {
    type = string
}

variable "pipeline_name" {
    type = string
}

variable "github_repo" {
    type = string
}