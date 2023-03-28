terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.59.0"
    }
  }
}

provider "aws" {
    region = var.region
    access_key = 
    secret_key = 
}

resource "aws_vpc" "my_vpc" {
 
  cidr_block = var.my_vpc_cidr
   tags = {
    Name = var.my_vpc_tag_name
    }
}
    
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  count = length(var.public_subnet_cidr)
  cidr_block = var.public_subnet_cidr[count.index]
  availability_zone = var.public_sub_az[count.index]
  tags = {
    Name = var.public_sub_tag_name[count.index] 
  }
} 

resource "aws_subnet" "private_subnet1" {
  vpc_id     = aws_vpc.my_vpc.id
  count = length(var.private_subnet1_cidr)
  cidr_block = var.private_subnet1_cidr[count.index]
   availability_zone = var.private_subnet1_az
  tags = {
    Name = var.private_sub1_tag_name[count.index]
  }
} 
resource "aws_subnet" "private_subnet2" {
  vpc_id     = aws_vpc.my_vpc.id
  count = length(var.private_subnet2_cidr)
  cidr_block = var.private_subnet2_cidr[count.index]
   availability_zone = var.private_subnet2_az
  tags = {
    Name = var.private_sub2_tag_name[count.index]
  }
} 

output "public_subnet_id" {
  value = [aws_subnet.public_subnet.*.id]
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "my_igw_task"
  }
}
/*data "aws_subnet_ids" "subnet_public" {
  count = length(var.public_subnet_cidr)
  vpc_id     = aws_vpc.my_vpc.id
  cidr_blocks = var.public_subnet_cidr[count.index]
}*/

resource "aws_route_table" "route_table_public" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
   tags = {
      Name = "my_route_table_public"
   }
}

resource "aws_route_table_association" "route_association_public1" {
   count = length(var.public_subnet_cidr)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.route_table_public.id
}

resource "aws_eip" "eip_task" {
  vpc = true
  count = length(var.nat_gateway_ips)
  
}
resource "aws_nat_gateway" "nat_pub1" {
  count = length(var.nat_gateway_ips)
 allocation_id = aws_eip.eip_task[count.index].id
  subnet_id     = aws_subnet.public_subnet[count.index].id
  connectivity_type = "public"
  tags = {
    Name = var.nat_gateway_tag[count.index]
  }
}
resource "aws_route_table" "route_table_private1" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_pub1[0].id
  }
   tags = {
      Name = "my_route_table_private1"
   }
}
resource "aws_route_table_association" "route_association_private1" {
  count = length(var.private_subnet1_cidr)
  subnet_id      = aws_subnet.private_subnet1[count.index].id
  route_table_id = aws_route_table.route_table_private1.id
}

resource "aws_route_table" "route_table_private2" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_pub1[1].id
  }
   tags = {
      Name = "my_route_table_private2"
   }
}
resource "aws_route_table_association" "route_association_private2" {
  count = length(var.private_subnet2_cidr)
  subnet_id      = aws_subnet.private_subnet2[count.index].id
  route_table_id = aws_route_table.route_table_private2.id
}

