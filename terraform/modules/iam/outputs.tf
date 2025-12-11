output "eb_service_role" {
    value       = aws_iam_role.eb_service_role.name
    description = "This is the Elastic Beanstalk IAM Service role name"
}

output "ec2_instance_profile" {
    value       = aws_iam_instance_profile.eb_ec2_instance_profile.name
    description = "This is the EC2 Instance IAM Profile name"
}

output "codebuild_service_role" {
    value       = aws_iam_role.codebuild_service_role.arn
    description = "This is CodeBuild IAM Service role ARN"
}

output "codepipeline_service_role" {
    value       = aws_iam_role.codepipeline_service_role.arn 
    description = "This is CodePipeline IAM Service role name"
}