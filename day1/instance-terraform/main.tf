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

  tags = {
    Name = var.name_of_instance
  }
}


resource "aws_s3_bucket" "test" {
  bucket = "shivani-first-bkt"
}




resource "aws_iam_role" "test_role" {
  name = "test_role"
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


resource "aws_iam_policy" "replication" {
  name = "tf-iam-role-policy-replication-12345"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    
     {
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": [
                "arn:aws:s3:::shivani-first-bkt",
                "arn:aws:s3:::shivani-first-bkt/*"
            ]
        },
        {
            "Effect": "Deny",
            "NotAction": "s3:*",
            "NotResource": [
                "arn:aws:s3:::shivani-first-bkt",
                "arn:aws:s3:::shivani-first-bkt/*"
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


