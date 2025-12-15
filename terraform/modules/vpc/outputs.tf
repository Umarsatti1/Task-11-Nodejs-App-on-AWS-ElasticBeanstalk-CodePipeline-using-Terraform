output "vpc_id" {
    value       = aws_vpc.vpc.id
    description = "This is the VPC ID"
}

output "public_subnets" {
    value       = [for subnet in aws_subnet.public_subnet : subnet.id]
    description = "VPC Public Subnet IDs"
}

output "private_subnets" {
    value       = [for subnet in aws_subnet.private_subnet : subnet.id]
    description = "VPC Private Subnet IDs"
}

output "db_subnets" {
    value       = [for subnet in aws_subnet.db_subnet : subnet.id]
    description = "VPC DB Subnet IDs"
}

output "alb_sg_id" {
    value       = aws_security_group.alb_sg.id
    description = "ALB Security Group ID"
}

output "ec2_sg_id" {
    value       = aws_security_group.ec2_sg.id
    description = "EC2 Instances Security Group ID"
}

output "db_sg_id" {
    value       = aws_security_group.rds_sg.id
    description = "RDS Security Group ID"
}