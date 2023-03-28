terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.59.0"
    }
  }
}

provider "aws" {
    region = var.aws_region
    access_key = "AKIA5RRZUWW4OYX3QNUK"
    secret_key = "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"
}

resource "aws_vpc" "my_vpc" {
 
  cidr_block = "10.0.0.0/24"
   tags = {
    Name = "my_vpc"
    }
}
    
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.0.0/28"

  tags = {
    Name = "public_subnet"
  }
} 

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "my_igw"
  }
}
resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
   tags = {
      Name = "my_route_table"
   }
}
resource "aws_route_table_association" "route_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_security_group" "sg_public" {

  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description      = "ssh connection"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "teraform_sg"
  }
}
resource "aws_instance" "prb_instance" {
  ami           = var.ami_instance
  instance_type = var.instance_type
  subnet_id = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.sg_public.id]
  key_name = var.key_pair
  #security_groups_id = aws_security_group.sg_public.id
  associate_public_ip_address = true
  tags = {
    Name = var.instance_name
  }
}