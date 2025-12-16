resource "aws_s3_bucket" "beanstalk_bucket" {
  bucket        = var.bucket_name
  force_destroy = true
}

/*
resource "aws_s3_object" "app_zip" { 
  bucket = aws_s3_bucket.beanstalk_bucket.bucket 
  key = "beanstalk/app.zip" 
  source = "${path.root}/../app.zip" 
}
*/

resource "aws_elastic_beanstalk_application" "eb_application" {
  name        = var.application_name
  description = "Elastic Beanstalk Nodejs application name"
}

/*
resource "aws_elastic_beanstalk_application_version" "app_version" {
  name        = "v1"
  application = aws_elastic_beanstalk_application.eb_application.name
  bucket      = aws_s3_bucket.beanstalk_bucket.bucket
  key         = aws_s3_object.app_zip.key
}
*/

resource "aws_elastic_beanstalk_environment" "eb_environment" {
  name                = var.environment_name
  application         = aws_elastic_beanstalk_application.eb_application.name
  solution_stack_name = var.platform
  #version_label       = aws_elastic_beanstalk_application_version.app_version.name

# Step 2: Configure service access
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

# Step 3: Set up networking, database, and tags
  # Instance settings
  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = var.vpc_id
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "AssociatePublicIpAddress"
    value     = false
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = join(",", var.private_subnets)
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBSubnets"
    value     = join(",", var.public_subnets)
  }

  # Load Balancer
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
    namespace = "aws:elbv2:listener:default"
    name      = "ListenerEnabled"
    value     = true
  }

  setting {
    namespace = "aws:elbv2:loadbalancer"
    name      = "IdleTimeout"
    value     = "600"
  }

# Step 4: Configure instance traffic and scaling

  # Part 1: Instances
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "RootVolumeType"
    value     = var.volume_type
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "RootVolumeSize"
    value     = var.volume_size
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "MonitoringInterval"
    value     = var.monitoring_interval
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "DisableIMDSv1"
    value     = true
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    value     = var.ec2_sg_id
  }

  # Part 2: Capacity
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = "1"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = "3"
  }

  setting {
    namespace = "aws:ec2:instances"
    name      = "InstanceTypes"
    value     = "t3.medium,t3.large"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "Cooldown"
    value     = "60"
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "MeasureName"
    value     = "CPUUtilization"
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "Statistic"
    value     = "Maximum"
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "Unit"
    value     = "Percent"
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "Period"
    value     = "1"
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "BreachDuration"
    value     = "2"
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "UpperThreshold"
    value     = "70"
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "LowerThreshold"
    value     = "30"
  }

# Step 5: Configure updates, monitoring, and logging
  setting {
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    name      = "SystemType"
    value     = "enhanced"
  }

  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    name      = "StreamLogs"
    value     = true
  }

  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    name      = "DeleteOnTerminate"
    value     = true
  }

  # Part 2: Email Notifications
  setting {
    namespace = "aws:elasticbeanstalk:sns:topics"
    name      = "Notification Endpoint"
    value     = var.alert_email
  }
  setting {
    namespace = "aws:elasticbeanstalk:sns:topics"
    name      = "Notification Protocol"
    value     = "email"
  }

  # Part 3: Rolling updates and deployments
  setting {
    namespace = "aws:elasticbeanstalk:command"
    name      = "DeploymentPolicy"
    value     = "AllAtOnce"
  }

  # Environment Variables for EB
  setting {
  namespace = "aws:elasticbeanstalk:application:environment"
  name      = "USE_LOCALHOST"
  value     = "false"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "DB_HOST"
    value     = var.db_address
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "DB_PORT"
    value     = "3306"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "DB_USER"
    value     = "umarsatti"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "DB_PASSWORD"
    value     = "umarsatti"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "DB_NAME"
    value     = "ecommerce"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "JWT_SECRET_KEY_ACCESS_TOKEN"
    value     = "272d68940619f58da65205c81da4fad16ae4629a2b32929c071fa554ea4da7390359e8ce3c7911de2e816b728ca609b67bec800932227ac5c7f6bd7cc558f0ae" 
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "JWT_SECRET_KEY_REFRESH_TOKEN"
    value     = "e6887d5ad961263d3f65c5ad66fbaf86e18fb29bb3e53d0fdec2446a0d9313376ac648625e66adb4f4d71800bdb82473854fa0852ed3ce4b9d696dbbd86bfa55" 
  }
}

# Testing Custom Metrics for CloudWatch Agent

# SNS Topic for Alerts
resource "aws_sns_topic" "alerts" {
  name = "${var.environment_name}-alerts"
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol = "email"
  endpoint = var.alert_email
}


# Scaling policy: Add instance(s)
resource "aws_autoscaling_policy" "scale_up" {
  name                   = "${var.environment_name}-scale-up"
  autoscaling_group_name = aws_elastic_beanstalk_environment.eb_environment.autoscaling_groups[0]
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1
  cooldown               = 60
}

# CloudWatch alarm to trigger scaling events and send notifications
resource "aws_cloudwatch_metric_alarm" "memory_high" {
  alarm_name          = "${var.environment_name}-memory-utilization-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "mem_used_percent"
  namespace           = "CWAgent"
  period              = 60
  statistic           = "Average"
  threshold           = 60

  dimensions = {
    AutoScalingGroupName = aws_elastic_beanstalk_environment.eb_environment.autoscaling_groups[0]
  }

  alarm_description = "Triggers if memory usage exceeds 60% on average for 2 minutes."
  
  alarm_actions = [
    aws_autoscaling_policy.scale_up.arn,
    aws_sns_topic.alerts.arn
  ]
}