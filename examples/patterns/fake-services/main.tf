data "terraform_remote_state" "tcm" {
  backend = "local"

  config = {
    path = "../../../terraform.tfstate"
  }
}

// fake-service on aws ec2

module "fake-service-ec2" {
  source = "./modules/fake-service-ec2"

  service_name        = "fake-service"

  deployment_id       = data.terraform_remote_state.tcm.outputs.deployment_id
  bastion_public_fqdn = data.terraform_remote_state.tcm.outputs.aws_bastion_public_fqdn
  consul_version      = data.terraform_remote_state.tcm.outputs.consul_client_version
  server_address      = data.terraform_remote_state.tcm.outputs.consul_server_private_ip
  client_acl_token    = data.terraform_remote_state.tcm.outputs.consul_initial_acl_token
  gossip_encrypt_key  = data.terraform_remote_state.tcm.outputs.consul_gossip_encrypt_key
}

// fake-service on aws eks

module "fake-service-eks" {
  source = "./modules/fake-service-eks"
}