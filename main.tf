terraform {
required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" { 
     bucket = "terraform-ajay-state"
     key = "ec-2_s32"
     region = "us-east-1"
   }
}

provider "aws" {
 region = "us-east-1"
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  key_name = "linux"

connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = "linux"
    host        = aws_instance.example.public_ip
  }

provisioner "remote-exec" {
  inline = [
    "apt-get install nginx",
    "systemctl start nginx",
    "mkdir page",
  ]
 }
}
