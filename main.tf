terraform {
  backend "s3" {
    bucket = "terraform-ajay-state"
    key="ec2-terra"
    region = "us-east-1"
  }
}
     
provider "aws" {
   region = "us-east-1"
}

variable "cidr" {
  default = "10.0.0.0/16"
}

resource "aws_vpc" "myvpc" {
  cidr_block = var.cidr
}

//resource "aws_key_pair" "ajay" {
  //key_name = "sample"
  //public_key = file("~/.ssh/sam.pub")
//}

resource "aws_subnet" "sub1" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id
}

resource "aws_route_table" "RT" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rta1" {
  subnet_id      = aws_subnet.sub1.id
  route_table_id = aws_route_table.RT.id
}

resource "aws_security_group" "webSg" {
  name   = "web"
  vpc_id = aws_vpc.myvpc.id

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
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
    Name = "Web-sg"
  }
}

resource "aws_instance" "example" {
  ami = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"
  //key_name = aws_key_pair.ajay.key_name
   key_name = "linux"
  vpc_security_group_ids = [aws_security_group.webSg.id]
  subnet_id              = aws_subnet.sub1.id


  connection {
    type = "ssh"
    user = "ubuntu"
    //private_key = file("~/.ssh/sam")
    private_key = "linux.pem"
    host = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [ 
      "sudo apt-get update",
      "sudo apt-get install -y nginx",
      "sudo apt-get install -y git",
      "mkdir code",
      "cd code",
      "git clone https://github.com/ajayreddy1998/Yeshlaptop.git",
      "cd Yeshlaptop",
      "sudo cp index.html /var/www/html",
     ]
  }
}
