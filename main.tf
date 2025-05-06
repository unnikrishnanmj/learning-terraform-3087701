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
  vpc_security_groups_ids = [aws_security_group.id]
  tags = {
    Name = "LI-TF-Course"
  }
}

resource "aws_security_group" "web"  {
  name  = "web"
  desc  = "allowed http inbound and outbound everthing"
  
  vpc.id  = data.aws_vpc.default.default.id
}

resource "aws_security_group_rule" "web_http_in"{
  type  =  "ingress"
  from_port  =  8080
  to_port  =  80
  
  cidr_blocks  = [0.0.0.0/0]
  protocol  =  "tcp"
  aws_security_group.id  =  aws_security_group.web.id
}
