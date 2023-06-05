locals {
  datacenter_name = "${join("-", slice(split("-", var.deployment_id), 0, 2))}-aws"
}

resource "kubernetes_namespace" "consul" {
  metadata {
    name = "consul"
  }
}

resource "kubernetes_secret" "consul-client-secrets" {
  metadata {
    name      = "${local.datacenter_name}-client-secrets"
    namespace = "consul"
  }

  data = {
    gossipEncryptionKey = var.gossip_encrypt_key
  }
}