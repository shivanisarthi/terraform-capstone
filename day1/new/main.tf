terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

variable "name_of_instance" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "TerraformInstance"
}

provider "aws" {
  profile = "default"
  region  = "us-west-2"
}

resource "aws_instance" "app_server" {
  ami           = "ami-830c94e3"
  instance_type = "t2.micro"

  associate_public_ip_address = true
key_name         = "devkey"


  tags = {
    Name = var.name_of_instance
  }
}


resource "aws_s3_bucket" "test" {
  bucket = "shivani-first-b1"
}


resource "aws_key_pair" "devkey" {
  key_name   = "devkey"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDE6yazq8+RLfkow50gM9NmmpIK9/zBupPATYuH1eqyxG+FdJo29/iNlFoGb/qUnYpmKBtYjY615kXvIUTDb/wMlbF7Xdwg5keie6CWc2WOoZUhtHXOULvwIhC184ZkAzx5LY4WD1Q57SQL40V+Tf0c8CId1VoLL229SveRXm+4UlHOJ26PfZtnC7pUUAqvRQi3Dtt8Tt8HIePzSCuvmRe6MM02udSxOaDP1K0JyRjiHgyjtNi9TbEm+Efhm9GvarWcToRwcwGm9DFFlanxCUmELIs0Fpb5EnGGI1Mz6mLRmTtWOemIateBtsL9HgfNVudC3osqw8opXc9hy6B8gjMUlQBV5ylwmUYvdJg+lzGInUrK1b14fM5I/jXZnaC/XiUy2M2P8hw0AnodToaT8/R3G6ybeVidFd1Ol+xSe1af1eu1X+UYM4ZQxFIuhao+wQROE5WfLQVCNUbF9fLX4H5yBPo6kDB16lw7Zv1sefEowkzi0fw632FTnFEu208vKwM= knoldus@knoldus-Vostro-15-3568"
}



resource "aws_iam_role" "test_role_main" {
  name = "test_role_main"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Sid": "ListObjectsInBucket",
            "Effect": "Allow",
            "Action": ["sts:AssumeRole"],
           Principal = {
          Service = "s3.amazonaws.com"
        }
      },
    ]
  })
  tags = {
    tag-key = "tag-value"
  }
}


resource "aws_iam_policy" "replication1" {
  name = "tf-iam-role-policy-replication-123456"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    
     {
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": [
                "arn:aws:s3:::shivani-first-b1",
                "arn:aws:s3:::shivani-first-b1/*"
            ]
        },
        {
            "Effect": "Deny",
            "NotAction": "s3:*",
            "NotResource": [
                "arn:aws:s3:::shivani-first-b1",
                "arn:aws:s3:::shivani-first-b1/*"
            ]
        }
  ]
}
POLICY
}







output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.app_server.id
}


output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.app_server.public_ip
}


