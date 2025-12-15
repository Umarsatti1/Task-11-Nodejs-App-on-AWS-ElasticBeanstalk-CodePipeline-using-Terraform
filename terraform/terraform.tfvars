# VPC Variables
vpc_cidr     = "172.20.0.0/16"
vpc_name     = "Umarsatti-VPC"
igw_name     = "Umarsatti-IGW"
eip_domain   = "vpc"
public_route = "0.0.0.0/0"

# IAM Variables
eb_service_role           = "ElasticBeanstalk-ServiceRole"
eb_policy                 = "ElasticBeanstalk-ServicePolicy"
ec2_service_role          = "ElasticBeanstalk-EC2InstanceRole"
ec2_policy                = "ElasticBeanstalk-EC2InstancePolicy"
codebuild_service_role    = "CodeBuild-EB-ServiceRole"
codebuild_policy          = "CodeBuild-EB-Permissions-Policy"
codepipeline_service_role = "CodePipeline-EB-ServiceRole"
codepipeline_policy       = "CodePipeline-EB-Permissions-Policy"


# Elastic Beanstalk Backend Variables
bucket_name         = "umarsatti-elastic-beanstalk-app-bucket"
application_name    = "umarsatti-nodejs-application"
environment_name    = "umarsatti-nodejs-environment"
platform            = "64bit Amazon Linux 2023 v6.7.0 running Node.js 24"
volume_type         = "gp3"
volume_size         = 10
monitoring_interval = "1 minute"
alert_email         = "umarsatti.15@gmail.com"

# CodeBuild Variables
codebuild_project_name = "CodeBuild-EB-Nodejs-Project"
account_id             = "504649076991"
region                 = "us-west-1"
codebuild_logs         = "CodeBuild-EB-Nodejs"

# CodePipeline Variables
pipeline_bucket_name = "codepipeline-us-west-1-umarsatti"
github_connection_arn = "arn:aws:codeconnections:us-west-1:504649076991:connection/26450667-fd5d-4d75-b056-35a6857547a6"
pipeline_name        = "CodePipeline-EB-Nodejs"
github_repo          = "Umarsatti1/Task-11-Nodejs-App-on-AWS-ElasticBeanstalk-CodePipeline-using-Terraform"
