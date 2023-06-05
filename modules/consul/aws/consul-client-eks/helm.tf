resource "local_file" "consul-client-helm-values" {
  content = templatefile("${path.root}/examples/templates/consul-client-eks-helm.yml.tpl", {
    datacenter_name    = "${local.datacenter_name}"
    consul_version     = var.consul_version
    consul_k8s_version = var.consul_k8s_version
    envoy_version      = var.envoy_version
    server_address     = var.server_address
    acl_token          = var.acl_token
    })
  filename = "${path.module}/configs/consul-client-eks-helm-values.yml.tmp"
}

# consul client
resource "helm_release" "consul-client" {
  name          = "${local.datacenter_name}-consul-client"
  chart         = "consul"
  repository    = "https://helm.releases.hashicorp.com"
  version       = var.consul_helm_chart_version
  namespace     = "consul"
  timeout       = "300"
  wait_for_jobs = true
  values        = [
    local_file.consul-client-helm-values.content
  ]

  depends_on    = [
    kubernetes_namespace.consul
  ]
}