// generic outputs

output "deployment_id" {
  description = "Deployment identifier"
  value       = local.deployment_id
}

// amazon web services (aws) outputs

output "aws_bastion_public_fqdn" {
  description = "AWS public fqdn of bastion node"
  value       = module.infra-aws.bastion_public_fqdn
}

// hashicorp self-managed consul outputs

output "consul_ui_url" {
  description = "Consul ui url"
  value       = "https://${module.consul-server.ui_fqdn}"
}

output "consul_intial_acl_token" {
  description = "Consul initial acl token"
  value       = random_uuid.consul-initial-acl-token.result
  sensitive   = true
}