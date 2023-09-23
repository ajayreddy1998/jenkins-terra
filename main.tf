provider "aws" {
   region = "us-east-1"
   profile = "default" 
}

variable "ami" {
  description = "this is to select the ami option "
}

variable "instance_type" {
 description = "this is for the type of instance "

}
 resource "aws_instance" "ec-2" {
   ami = "ami-053b0d53c279acc90"
   instance_type = "t2.micro"
   key_name = "linux"
}
