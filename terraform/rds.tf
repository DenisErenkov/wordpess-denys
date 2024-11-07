resource "aws_db_instance" "wordpress_db" {
  identifier = "${var.name}-wordrpess-rds"
  allocated_storage    = 20
  engine              = "mysql"
  engine_version      = "8.0"
  instance_class      = "db.t3.micro"
  db_name             = "wordpress"
  username            = "admin"
  password            = var.db_password 
  parameter_group_name = "default.mysql8.0"
  multi_az            = false
  publicly_accessible = false
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name  = aws_db_subnet_group.db_subnet_group.name
  tags = {
    Name = "WordPress RDS"
  }
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "${var.name}-wordpress-db-subnet-group"
  subnet_ids = [
    aws_subnet.public_subnet.id,
    aws_subnet.public_subnet_2.id
  ]
  tags = {
    Name = "DB Subnet Group"
  }
}
