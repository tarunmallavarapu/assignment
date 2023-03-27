resource "aws_db_instance" "uat_rds" {
  allocated_storage    = 10
  db_subnet_group_name = data.aws_db_subnet_group.data_group.name
  db_name              = "uatdb"
  engine               = "postgres"
  engine_version       = "14.1"
  instance_class       = "db.t3.micro"
  username             = var.db_username
  password             = var.db_password
  multi_az             = false
  port                 = 5432
  skip_final_snapshot  = true
  storage_encrypted    = true
  vpc_security_group_ids = ["${aws_security_group.uat_rds_sg.id}"]

  depends_on = [
      resource.aws_db_subnet_group.data
    ]
}

resource "aws_security_group" "uat_rds_sg" {
    name  = "uatdbsg"

    vpc_id = aws_vpc.vpc.id

    ingress {
        from_port = 5432
        to_port   = 5432
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }

    depends_on = [
      resource.aws_vpc.vpc
    ]
  
}