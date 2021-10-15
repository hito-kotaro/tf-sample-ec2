

provider "aws" {

  region = var.region
}

resource "aws_vpc" "vpc" {
  cidr_block           = "10.1.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "false"
  tags = {
    Name = "${var.tag_name}-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.tag_name}-igw"
  }
}

resource "aws_subnet" "subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.1.0.0/24"
  availability_zone = "ap-northeast-1a"
  tags = {
    Name = "${var.tag_name}-sbn-1a"
  }
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.tag_name}-rtb"
  }
}

resource "aws_route_table_association" "route_assoc" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.route_table.id
}


resource "aws_security_group" "sg-ssh" {
  name        = "tf-hito-sg-ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.tag_name}-sg-ssh"
  }
}

resource "aws_security_group" "sg-http" {
  name        = "tf-hito-sg-http"
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.tag_name}-sg-http"
  }
}

resource "aws_instance" "ec2" {
  count         = var.ec2_cnt
  ami           = var.images.ap-northeast-1
  instance_type = "t2.micro"
  key_name      = var.key_name
  vpc_security_group_ids = [
    "${aws_security_group.sg-ssh.id}",
    "${aws_security_group.sg-http.id}"
  ]
  subnet_id                   = aws_subnet.subnet.id
  associate_public_ip_address = "true"
  tags = {
    Name = "${var.tag_name}-ec2-${count.index + 1}"
  }
}