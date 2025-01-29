output "vpc_id" {
    description = "ID of vpc"
    value = aws_vpc.main.id
}

output "subnet_1_id" {
  description = "The ID of the created subnet"
  value       = aws_subnet.subnet_1.id
}

output "subnet_2_id" {
  description = "The ID of the created subnet"
  value       = aws_subnet.subnet_2.id
}

output "internet_gateway_id" {
  description = "internet gateway id"
  value = aws_internet_gateway.igw.id
}
