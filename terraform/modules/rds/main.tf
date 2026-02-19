resource "aws_db_instance" "memos" {
  allocated_storage      = 10
  db_name                = var.db_name
  engine                 = "postgres"
  engine_version         = "18"
  instance_class         = "db.t3.micro"
  username               = var.username
  password               = var.password
  vpc_security_group_ids = [var.rds_sg]
  db_subnet_group_name   = aws_db_subnet_group.default.name
  skip_final_snapshot    = true
  apply_immediately      = true
  port                   = var.port
}

resource "aws_db_subnet_group" "default" {
  name        = "my-db-subnet-group"
  subnet_ids  = var.private_subnets_id
  description = "Private subnets for RDS"
}
