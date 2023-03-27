resource "aws_security_group" "stage-sgs" {
  name = "stage-sgs"
  vpc_id = aws_vpc.vpc.id

  // To Allow SSH Transport
  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 5000
    protocol = "tcp"
    to_port = 5000
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 5432
    protocol = "tcp"
    to_port = 5432
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
  depends_on = [
    aws_vpc.vpc
  ]
}




resource "aws_instance" "stage_ec2" {
  ami = var.stage_ami
  instance_type = "t2.medium"
  subnet_id = data.aws_subnet.public.id
  associate_public_ip_address = true
  key_name = "test12"


  vpc_security_group_ids = [
    aws_security_group.stage-sgs.id
  ]
  root_block_device {
    delete_on_termination = true
    volume_size = 50
    volume_type = "gp2"
  }
  

  depends_on = [ aws_security_group.stage-sgs ]
}
