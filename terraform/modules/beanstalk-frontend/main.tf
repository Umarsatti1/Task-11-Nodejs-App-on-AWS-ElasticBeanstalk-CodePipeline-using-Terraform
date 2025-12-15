resource "aws_elastic_beanstalk_application" "eb_application" {
  name        = var.frontend_application_name
  description = "Elastic Beanstalk React frontend"
}

resource "aws_elastic_beanstalk_environment" "eb_environment" {
  name                = var.frontend_environment_name
  application         = aws_elastic_beanstalk_application.eb_application.name
  solution_stack_name = var.frontend_platform
  
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "ServiceRole"
    value     = var.eb_service_role
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = var.ec2_instance_profile
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "LoadBalanced"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "LoadBalancerType"
    value     = "application"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = var.vpc_id
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = join(",", var.public_subnets)
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = "1"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = "2"
  }

  # React env var
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "REACT_APP_API_URL"
    value     = var.backend_api_url
  }

  depends_on = [ module.beanstalk-backend.eb_environment ]
}
