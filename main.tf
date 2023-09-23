Terraform
{
  backend "s3"
   { 
     Bucket = "terraform-ajay-state"
     keyname = "ec-2_s3"
     region = "us-east-1"
   }
}


provider "aws" {
   region = "us-east-1"
   profile = "default" 
}

 resource "aws_instance" "ec-2" {
   ami = "ami-053b0d53c279acc90"
   instance_type = "t2.micro"
   key_name = "linux"
}
