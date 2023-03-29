resource "aws_security_group" "prod-sgs" {
  name = "prod-sgs"
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




resource "aws_instance" "prod_ec2" {
  ami = var.bastion_ami
  instance_type = "t2.medium"
  subnet_id = data.aws_subnet.public.id
  associate_public_ip_address = true
  key_name = "test12"


  vpc_security_group_ids = [
    aws_security_group.prod-sgs.id
  ]
  root_block_device {
    delete_on_termination = true
    volume_size = 50
    volume_type = "gp2"
  }

  depends_on = [ aws_security_group.prod-sgs ]
}


resource "aws_launch_template" "prod_lt" {
  name = "prod_lt"

  block_device_mappings {
    device_name = "/dev/sdf"
    ebs {
      volume_size = 20
    }
  }

  image_id = var.prod_ami

  instance_type = "t2.medium"

  key_name = "test12"

  monitoring {
    enabled = true
  }

  vpc_security_group_ids = [
    aws_security_group.prod-sgs.id
  ]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "test"
    }
  }

}

resource "aws_autoscaling_group" "prod_asg" {
  vpc_zone_identifier = aws_subnet.app.*.id
  desired_capacity   = 2
  max_size           = 2
  min_size           = 2
  target_group_arns = [
    aws_lb_target_group.prod_tg.arn
  ]

  launch_template {
    id      = aws_launch_template.prod_lt.id
    version = "$Latest"
  }
}

resource "aws_lb" "prod" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [
    aws_security_group.prod-sgs.id
  ]
  subnets            = aws_subnet.public.*.id

  enable_deletion_protection = false

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_target_group" "prod_tg" {
  name     = "http"
  port     = 5000
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id

  health_check {
    port     = 5000
    protocol = "HTTP"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "prod_http" {
  load_balancer_arn = aws_lb.prod.id
  port              = "5000"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.prod_tg.id
    type             = "forward"
  }
}