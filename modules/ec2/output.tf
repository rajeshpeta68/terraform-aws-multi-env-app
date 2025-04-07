
output "aws_security_group_ec2" {
  value = aws_security_group.autoec2sg.id
}
output "aws_subnet_ids_public" {
  value = [aws_subnet.autopublicsubnetA.id, aws_subnet.autopublicsubnetB.id]
}
