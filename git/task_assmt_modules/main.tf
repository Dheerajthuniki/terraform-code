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
    access_key = "AKIA5RRZUWW4OYX3QNUK"
    secret_key = "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"
}

module "my_dev_vpc" {
  source = "../task_assmt"
  my_vpc_cidr = "12.0.0.0/24"
  public_subnet1_cidr = "12.0.0.0/28"
  public_subnet2_cidr = "12.0.0.16/28"
  private_subnet1_cidr = "12.0.0.32/28"
  private_subnet2_cidr = "12.0.0.48/28"
  private_subnet1_db_cidr = "12.0.0.64/28"
  private_subnet2_db_cidr = "12.0.0.80/28"
}  
