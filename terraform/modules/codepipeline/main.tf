# S3 Bucket for CodePipeline Artifacts
resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket        = var.pipeline_bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "codepipeline_bucket_access" {
  bucket                  = aws_s3_bucket.codepipeline_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Use existing GitHub App CodeStar Connection
data "aws_codestarconnections_connection" "github" {
  arn = var.github_connection_arn
}

# CodePipeline
resource "aws_codepipeline" "pipeline" {
  name     = var.pipeline_name
  role_arn = var.codepipeline_service_role

  artifact_store {
    type     = "S3"
    location = aws_s3_bucket.codepipeline_bucket.bucket
  }

  # Source Stage
  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["SourceArtifact"]

      configuration = {
        ConnectionArn        = data.aws_codestarconnections_connection.github.arn
        FullRepositoryId     = var.github_repo
        BranchName           = "main"
        OutputArtifactFormat = "CODEBUILD_CLONE_REF"
        DetectChanges        = "true"
      }
    }
  }

  # Build Stage
  stage {
    name = "Build"
    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["BuildArtifact"]

      configuration = {
        ProjectName = var.codebuild_project_name
      }
    }
  }

  # Deploy Backend Stage
  stage {
    name = "DeployBackend"
    action {
      name            = "DeployBackend"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ElasticBeanstalk"
      version         = "1"
      input_artifacts = ["BuildArtifact"]

      configuration = {
        ApplicationName = var.backend_application_name
        EnvironmentName = var.backend_environment_name
        # Optional: specify S3 artifact path if needed
        # VersionLabel     = "v1"
      }
    }
  }

  # Deploy Frontend Stage
  stage {
    name = "DeployFrontend"
    action {
      name            = "DeployFrontend"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ElasticBeanstalk"
      version         = "1"
      input_artifacts = ["BuildArtifact"]

      configuration = {
        ApplicationName = var.frontend_application_name
        EnvironmentName = var.frontend_environment_name
        # Optional: specify S3 artifact path if needed
        # VersionLabel     = "v1"
      }
    }
  }
}
