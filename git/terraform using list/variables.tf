variable "region" {
    type = string 
    default = "ap-south-1"
}
variable "my_vpc_cidr" {
    type = string
    default = "10.11.0.0/24"
}
variable "my_vpc_tag_name" {
    type = string
    default = "my_sample_vpc"
}
variable "public_subnet_cidr" {
    type = list(string)
    default = ["10.11.0.0/28", "10.11.0.16/28"]
  
}
variable "public_sub_az" {
    type = list(string)
    default = ["ap-south-1a", "ap-south-1b"]
}
variable "public_sub_tag_name" {
  type = list(string)
  default = ["public-sub1", "public-sub2"]
}
/*variable "public_subnet_ids" {
  type = list(string)
  default = ["subnet-123", "subnet-456"]
}*/
variable "private_subnet1_cidr" {
    type = list(string)
    default = ["10.11.0.32/28", "10.11.0.48/28"]
  
}
variable "private_sub1_tag_name" {
  type = list(string)
  default = ["private_sub1", "private_sub_db1"]
}
variable "private_subnet1_az" {
    type = string
    default = "ap-south-1a"  
}

variable "private_subnet2_cidr" {
    type = list(string)
    default = ["10.11.0.64/28", "10.11.0.80/28"]
  
}
variable "private_sub2_tag_name" {
  type = list(string)
  default = ["private_sub2", "private_sub_db2"]
}
variable "private_subnet2_az" {
    type = string
    default = "ap-south-1b"  
}
variable "nat_gateway_ips" {
  type    = list(string)
  default = ["10.11.0.6", "10.11.0.12"]
}

variable "nat_gateway_tag" {
  type    = list(string)
  default = ["NAT1", "NAT2"]
}
