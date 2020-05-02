output "vpc_id" {
  value = aws_vpc.this.id
}

output "subnet_ids" {
  value = [
    aws_subnet.pub_0.id,
    aws_subnet.pub_1.id,
    aws_subnet.priv_0.id,
    aws_subnet.priv_1.id
  ]
}

output "public_subnet_ids" {
  value = [
    aws_subnet.pub_0.id,
    aws_subnet.pub_1.id
  ]
}

output "private_subnet_ids" {
  value = [
    aws_subnet.priv_0.id,
    aws_subnet.priv_1.id
  ]
}

output "bastion_security_group_id" {
  value = aws_security_group.bastion.id
}
