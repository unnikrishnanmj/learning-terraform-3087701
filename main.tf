data "aws_ami" "app_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["bitnami-tomcat-*-x86_64-hvm-ebs-nami"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["979382823631"] # Bitnami
}

data "aws_vpc" "default"  {
  default  =  true
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.app_ami.id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.web.id]
  tags = {
    Name = "LI-TF-Course"
  }
}

resource "aws_security_group" "web"  {
  name  = "web"
  
  vpc_id  = data.aws_vpc.default.id
}

resource "aws_security_group_rule" "web_http_in" {
  type  =  "ingress"
  from_port  =  8080
  to_port  =  80
  
  cidr_blocks  = ["0.0.0.0/0"]
  protocol  =  "tcp"
  security_group_id  =  aws_security_group.web.id
}

resource "aws_security_group_rule" "web_http_out" {
  type  =  "ingress"
  from_port  =  0
  to_port  =  0
  
  cidr_blocks  = ["0.0.0.0/0"]
  protocol  =  "-1"
  security_group_id  =  aws_security_group.web.id
}
