provider "aws" {
  profile = "default"
  region  = "us-east-2"
}

module "aws"{
 source= "./aws"
sub= module.vpc.subnet_aws_id
#security= module.vpc.security_sg
}

module "vpc"{
source= "./vpc"
 }
