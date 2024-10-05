resource "aws_security_group" "posweb_myapp_2024_sg" {
  name        = "posweb_myapp_2024"
  description = "Allow MyAPP inbound traffic and all outbound traffic"
  vpc_id      = aws_default_vpc.default.id

  tags = {
    Name = "posweb_myapp_2024_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "posweb_myapp_2024_allow_ssh" {
  security_group_id = aws_security_group.posweb_myapp_2024_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "posweb_myapp_2024_allow_http" {
  security_group_id = aws_security_group.posweb_myapp_2024_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "posweb_myapp_2024_allow_api" {
  security_group_id = aws_security_group.posweb_myapp_2024_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 5000
  ip_protocol       = "tcp"
  to_port           = 5000
}

resource "aws_vpc_security_group_ingress_rule" "posweb_myapp_2024_allow_api2" {
  security_group_id = aws_security_group.posweb_myapp_2024_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 5001
  ip_protocol       = "tcp"
  to_port           = 5001
}


resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.posweb_myapp_2024_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}