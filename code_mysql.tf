provider "aws" {
  region     = "ap-south-1"
  profile    = "aman"
}
resource "aws_db_instance" "mysql-db" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  vpc_security_group_ids = [aws_security_group.sg.id]
  identifier           = "mysqldb"
  name                 = "mysqldb"
  username             = "aman"
  password             = "Amaner123"
  parameter_group_name = "default.mysql5.7"
  publicly_accessible = true
  skip_final_snapshot = true
}

data "http" "myip"{
  url = "http://ipv4.icanhazip.com"
}

resource "aws_security_group" "sg" {
  name        = "mysql-sg"

  ingress {
    description = "only 3306 port for MySQL"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
  }
 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
tags = {
    Name = "mysql-sg"
  }
}

output "dns"{
  value = aws_db_instance.mysql-db.address
}