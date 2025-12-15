output "eb_application_name" {
    value       = aws_elastic_beanstalk_application.eb_application.name
    description = "This is the Elastic Beanstalk application name"
}

output "eb_environment_name" {
    value       = aws_elastic_beanstalk_environment.eb_environment.name
    description = "This is the Elastic Beanstalk environment name"
}