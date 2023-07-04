output "private_ip" {
  description = "private ip"
  value       = aws_instance.fake-service.private_ip
}