output "ca_key" {
  description = "ca key"
  value       = tls_private_key.ca-key.private_key_pem
}

output "ca_cert" {
  description = "ca cert"
  value       = tls_self_signed_cert.ca-cert.cert_pem
}

output "private_fqdn" {
  description = "private fqdn"
  value       = aws_instance.consul-server.private_dns
}

output "private_ip" {
  description = "private ip"
  value       = aws_instance.consul-server.private_ip
}

output "ui_fqdn" {
  description = "ui fqdn"
  value       = aws_route53_record.consul-ui.fqdn
}