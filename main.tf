terraform {
required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" { 
     bucket = "terraform-ajay-state"
     key = "ec-2_s3"
     region = "us-east-1"
   }
}
provider "aws" {
   region = "us-east-1"
}

 resource "aws_instance" "ec-2" {
   ami = "ami-053b0d53c279acc90"
   instance_type = "t2.micro"
   key_name = "linux"
}
