sprovider "aws" {

 region = "us-east-2"
}

variable "cidr_vpc" {
  description = "CIDR block for the VPC"
  default = "10.1.0.0/16"
}
variable "cidr_subnet" {
  description = "CIDR block for the subnet"
  default = "10.1.0.0/24"
}
variable "availability_zone" {
  description = "availability zone to create subnet"
  default = "us-east-2a"
}
variable "public_key_path" {
  description = "Public key path"
  default = "~/.ssh/id_rsa.pub"
}
variable "instance_ami" {
  description = "AMI for aws EC2 instance"
  default = "ami-0cf31d971a3ca20d6"
}
variable "instance_type" {
  description = "type for aws EC2 instance"
  default = "t2.micro"
}


resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_vpc
  enable_dns_support   = true
  enable_dns_hostnames = true
  
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  
}

resource "aws_subnet" "subnet_public" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.cidr_subnet
  map_public_ip_on_launch = "true"
  availability_zone = var.availability_zone
  
}



resource "aws_route_table" "rtb_public" {
  vpc_id = aws_vpc.vpc.id
route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.igw.id
  }
}


resource "aws_route_table_association" "rta_subnet_public" {
  subnet_id      = aws_subnet.subnet_public.id
  route_table_id = aws_route_table.rtb_public.id
}



resource "aws_security_group" "sg_22" {
  name = "sg_22"
  vpc_id = aws_vpc.vpc.id
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
  
}




resource "aws_key_pair" "ssh-key" {
  key_name   = "devkey"
 public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDE6yazq8+RLfkow50gM9NmmpIK9/zBupPATYuH1eqyxG+FdJo29/iNlFoGb/qUnYpmKBtYjY615kXvIUTDb/wMlbF7Xdwg5keie6CWc2WOoZUhtHXOULvwIhC184ZkAzx5LY4WD1Q57SQL40V+Tf0c8CId1VoLL229SveRXm+4UlHOJ26PfZtnC7pUUAqvRQi3Dtt8Tt8HIePzSCuvmRe6MM02udSxOaDP1K0JyRjiHgyjtNi9TbEm+Efhm9GvarWcToRwcwGm9DFFlanxCUmELIs0Fpb5EnGGI1Mz6mLRmTtWOemIateBtsL9HgfNVudC3osqw8opXc9hy6B8gjMUlQBV5ylwmUYvdJg+lzGInUrK1b14fM5I/jXZnaC/XiUy2M2P8hw0AnodToaT8/R3G6ybeVidFd1Ol+xSe1af1eu1X+UYM4ZQxFIuhao+wQROE5WfLQVCNUbF9fLX4H5yBPo6kDB16lw7Zv1sefEowkzi0fw632FTnFEu208vKwM= knoldus@knoldus-Vostro-15-3568"
}





resource "aws_instance" "testInstance" {
  ami           = var.instance_ami
  instance_type = var.instance_type
  subnet_id = aws_subnet.subnet_public.id
  vpc_security_group_ids = [aws_security_group.sg_22.id]
  key_name = "devkey"
 
}
