# Create an RDS Parameter Group
resource "aws_db_parameter_group" "rds_parameter_group" {
  name        = "${var.db_engine}-parameter-group"
  family      = var.db_group_family
  description = "RDS parameter group for ${var.db_engine}"
  tags = {
    Name = "${var.vpc_name}-rds-pg"
  }
}

# Create RDS instance
resource "aws_db_instance" "rds_instance" {
  identifier             = "csye6225"
  engine                 = var.db_engine
  instance_class         = "db.t3.micro"
  allocated_storage      = 15
  username               = var.db_username
  password               = random_password.db_password.result
  kms_key_id             = aws_kms_key.rds_kms.arn
  db_name                = var.db_name
  parameter_group_name   = aws_db_parameter_group.rds_parameter_group.name
  publicly_accessible    = false
  vpc_security_group_ids = [aws_security_group.db_security_group.id]
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  skip_final_snapshot    = true
  storage_encrypted      = true

  tags = {
    Name = "${var.vpc_name}-rds-instance"
  }
}