output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "fargate_sg_id" {
  value = aws_security_group.fargate_sg.id
}

output "vpc_id" {
  value = aws_vpc.this.id
}

output "rds_sg_id" {
  value = aws_security_group.rds_sg.id
}


