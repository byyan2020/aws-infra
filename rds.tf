resource "aws_db_parameter_group" "pg_webapp" {
  name   = "my-pg"
  family = "postgres15"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_db_subnet_group" "private_subnet_group" {
  name       = "private-db-subnet-group"
  subnet_ids = [for subnet in values(aws_subnet.private_subnets) : subnet.id]
}

resource "aws_db_instance" "postgresql" {
  db_name                = "csye6225"
  engine                 = "postgres"
  engine_version         = "15"
  instance_class         = "db.t3.micro"
  multi_az               = false
  identifier             = "csye6225"
  username               = "csye6225"
  password               = "csye6225webapp"
  db_subnet_group_name   = aws_db_subnet_group.private_subnet_group.name
  publicly_accessible    = false
  allocated_storage      = 10
  parameter_group_name   = aws_db_parameter_group.pg_webapp.name
  vpc_security_group_ids = [aws_security_group.database_sg.id]
  skip_final_snapshot    = true
  storage_encrypted      = true
  kms_key_id             = aws_kms_key.kms_rds.arn
}