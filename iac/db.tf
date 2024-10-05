resource "aws_db_instance" "myapp_db" {
  allocated_storage    = 10
  db_name              = "myapp"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = "myapp_user"
  password             = "myapp_passwd"
  parameter_group_name = "default.mysql8.0"
  vpc_security_group_ids = [aws_security_group.posweb_mydb_2024_sg.id]
  skip_final_snapshot  = true
}

resource "aws_security_group" "posweb_mydb_2024_sg" {
  name        = "posweb_mydb_2024"
  description = "Allow MYDB inbound traffic and all outbound traffic"
  vpc_id      = aws_default_vpc.default.id

  tags = {
    Name = "posweb_mydb_2024_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "posweb_mydb_2024_allow_mysql" {
  security_group_id = aws_security_group.posweb_mydb_2024_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 3306
  ip_protocol       = "tcp"
  to_port           = 3306
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4_mydb" {
  security_group_id = aws_security_group.posweb_mydb_2024_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}