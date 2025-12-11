# VPC Variables
module "vpc" {
    source       = "./modules/vpc"
    vpc_cidr     = var.vpc_cidr
    vpc_name     = var.vpc_name
    igw_name     = var.igw_name
    eip_domain   = var.eip_domain
    public_route = var.public_route
}

module "iam" {
    source                    = "./modules/iam"
    eb_service_role           = var.eb_service_role
    eb_policy                 = var.eb_policy
    ec2_service_role          = var.ec2_service_role
    ec2_policy                = var.ec2_policy
    codebuild_service_role    = var.codebuild_service_role
    codebuild_policy          = var.codebuild_policy
    codepipeline_service_role = var.codepipeline_service_role
    codepipeline_policy       = var.codepipeline_policy
}

module "beanstalk" {
    source               = "./modules/beanstalk"
    eb_service_role      = module.iam.eb_service_role
    ec2_instance_profile = module.iam.ec2_instance_profile
    vpc_id               = module.vpc.vpc_id
    public_subnets       = module.vpc.public_subnets
    private_subnets      = module.vpc.private_subnets
    ec2_sg_id            = module.vpc.ec2_sg_id
    bucket_name          = var.bucket_name
    application_name     = var.application_name
    environment_name     = var.environment_name
    platform             = var.platform 
    volume_type          = var.volume_type
    volume_size          = var.volume_size
    monitoring_interval  = var.monitoring_interval
    alert_email          = var.alert_email
}

module "codebuild" {
    source                 = "./modules/codebuild"
    vpc_id                 = module.vpc.vpc_id
    private_subnet_ids     = module.vpc.private_subnets
    private_sg_id          = module.vpc.ec2_sg_id
    codebuild_service_role = module.iam.codebuild_service_role
    codebuild_project_name = var.codebuild_project_name
    region                 = var.region
    account_id             = var.account_id
    codebuild_logs         = var.codebuild_logs
}

module "codepipeline" {
    source = "./modules/codepipeline"
    codebuild_project_arn     = module.codebuild.codebuild_project_arn
    codebuild_project_name    = module.codebuild.codebuild_project_name
    codepipeline_service_role = module.iam.codepipeline_service_role
    eb_application_name       = module.beanstalk.eb_application_name
    eb_environment_name       = module.beanstalk.eb_environment_name
    pipeline_bucket_name      = var.pipeline_bucket_name
    github_connection_arn     = var.github_connection_arn
    pipeline_name             = var.pipeline_name
    github_repo               = var.github_repo
}
