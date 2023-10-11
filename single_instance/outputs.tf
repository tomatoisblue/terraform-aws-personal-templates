output "instance_public_ip_addr" {
  description = "public ip address of an instance."
  value       = aws_instance.example.public_ip
}