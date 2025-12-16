resource "aws_db_subnet_group" "db_subnet" {
  name       = "db-subnet"
  subnet_ids = var.db_subnets

  tags = {
    Name = "DB Subnet group"
  }
}

resource "aws_db_instance" "mysql" {
  identifier              = "ecommerce"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  db_name                 = "ecommerce"
  username                = "umarsatti"
  password                = "umarsatti"
  skip_final_snapshot     = true
  publicly_accessible     = false

  vpc_security_group_ids  = [var.db_sg_id]
  db_subnet_group_name    = aws_db_subnet_group.db_subnet.name
}