output "fake_service_server_private_ip" {
  description = "fake-service server private ip"
  value       = module.fake-service-ec2.private_ip
}