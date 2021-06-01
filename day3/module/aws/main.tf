variable sub{
type=string
}

#variable security{
#type= string
#}



resource "aws_instance" "instance1" {
    ami = "ami-0b9064170e32bde34"
    instance_type = "t2.micro"
    key_name = "devkey"
   # security_groups = var.security
    iam_instance_profile = aws_iam_instance_profile.test_profile_1.name
     subnet_id = var.sub
      tags = {
      Name = "instance"
    }
}

resource "aws_s3_bucket" "shivanisarthibucket" {
  bucket = "shivanisarthibucket"
  acl    = "private"

  tags = {
    Name        = "shivanisarthibucket"
    Environment = "Dev"
  }
}

resource "aws_iam_instance_profile" "test_profile_1" {
  name = "test_profile_1"
  role = "${aws_iam_role.test_role.name}"
}


resource "aws_iam_role" "test_role" {
  name = "test_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "tag-value"
  }
}

resource "aws_iam_role_policy" "test_policy" {
  name = "test_policy"
  role = aws_iam_role.test_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": [
                "arn:aws:s3:::shivanisarthibucket",
                "arn:aws:s3:::shivanisarthibucket/*"
            ]
        },
    ]
  })
}

















resource "aws_key_pair" "ssh-key" {
  key_name   = "devkey"
 public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDE6yazq8+RLfkow50gM9NmmpIK9/zBupPATYuH1eqyxG+FdJo29/iNlFoGb/qUnYpmKBtYjY615kXvIUTDb/wMlbF7Xdwg5keie6CWc2WOoZUhtHXOULvwIhC184ZkAzx5LY4WD1Q57SQL40V+Tf0c8CId1VoLL229SveRXm+4UlHOJ26PfZtnC7pUUAqvRQi3Dtt8Tt8HIePzSCuvmRe6MM02udSxOaDP1K0JyRjiHgyjtNi9TbEm+Efhm9GvarWcToRwcwGm9DFFlanxCUmELIs0Fpb5EnGGI1Mz6mLRmTtWOemIateBtsL9HgfNVudC3osqw8opXc9hy6B8gjMUlQBV5ylwmUYvdJg+lzGInUrK1b14fM5I/jXZnaC/XiUy2M2P8hw0AnodToaT8/R3G6ybeVidFd1Ol+xSe1af1eu1X+UYM4ZQxFIuhao+wQROE5WfLQVCNUbF9fLX4H5yBPo6kDB16lw7Zv1sefEowkzi0fw632FTnFEu208vKwM= knoldus@knoldus-Vostro-15-3568"
}


