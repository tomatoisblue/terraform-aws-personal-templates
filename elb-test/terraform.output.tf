output "NAT_gateway_EIP" {
  description = "The public IP assigned to the instance."
  value       = aws_eip.default.public_ip
}

output "EC2_1a_Public_IP" {
  value = aws_instance.default[0].public_ip
}

output "EC2_1c_Public_IP" {
  value = aws_instance.default[1].public_ip
}