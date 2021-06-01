 
 output "subnet_aws_id" {
  value = aws_subnet.subnet_public.id
}


output "security_sg"{
value =aws_security_group.sg_22.name

}
 
 

