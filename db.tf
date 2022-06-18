resource "aws_db_instance" "mysql_rds_db" {
  count = 1
  allocated_storage      = 10
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t3.micro"
  db_name                = "mydb"
  username               = "foo"
  password               = "foobarbaz"
  parameter_group_name   = "default.mysql5.7"
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.rds_secgrp.id]
  db_subnet_group_name   = element(aws_db_subnet_group.dbsubnet.*.id, count.index)
}

#DB instance will be created in the VPC associated with the DB subnet group. 
#If unspecified, will be created in the default VPC, or in EC2 Classic,
resource "aws_db_subnet_group" "dbsubnet" {
  name       = "subnet group for the rds database instance"
  
  subnet_ids = aws_subnet.public.*.id

  tags = {
    Name = "My DB subnet group"
  }
}

