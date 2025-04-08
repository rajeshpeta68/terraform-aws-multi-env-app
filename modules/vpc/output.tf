output "vpc_id" {
  value = aws_vpc.bny.id 
}

output "aws_security_group_ec2" {
  value = aws_security_group.bnysg-ec2.id  
}
output "aws_security_group_alb" {
  value = aws_security_group.bnysg-alb.id  
}
output "aws_subnet_ids_public" {
  value = [aws_subnet.bnypublicsubnetA.id,aws_subnet.bnypublicsubnetB.id]
}
output "aws_internet_gateway" {
  value = aws_internet_gateway.bny-igw.id   
}
output "aws_private_subnet_ids" {
  value = [aws_subnet.bnyprivatesubnetA.id,aws_subnet.bnyprivatesubnetB.id]
  
}

output "aws_security_group_rds" {
  value = aws_security_group.bnysg-rds.id  
}