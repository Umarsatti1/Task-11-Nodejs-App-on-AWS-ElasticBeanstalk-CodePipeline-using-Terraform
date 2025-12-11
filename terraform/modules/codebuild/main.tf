resource "aws_codebuild_project" "codebuild" {
  name         = var.codebuild_project_name
  description  = "Nodejs application CodeBuild project"
  service_role = var.codebuild_service_role

  artifacts {
    type = "CODEPIPELINE"
  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/Umarsatti1/Task-11-Nodejs-App-on-AWS-ElasticBeanstalk-CodePipeline-using-Terraform.git"
    git_clone_depth = 1
    buildspec       = "buildspec.yml"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/ami/amazonlinux-x86_64-base:latest"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = true
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "ACCOUNT_ID"
      value = var.account_id
      type  = "PLAINTEXT"
    }

    environment_variable {
      name  = "REGION"
      value = var.region
      type  = "PLAINTEXT"
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name = var.codebuild_logs
    }
  }

  /*
  source {
    type = "CODEPIPELINE"
  }
  */

  vpc_config {
    vpc_id             = var.vpc_id
    subnets            = var.private_subnet_ids
    security_group_ids = [var.private_sg_id]
  }
}