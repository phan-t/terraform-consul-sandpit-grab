global:
  enabled: false
  name: consul
  image: "hashicorp/consul-enterprise:${consul_version}-ent"
  imageK8S: "hashicorp/consul-k8s-control-plane:${consul_k8s_version}"
  imageEnvoy: "envoyproxy/envoy-alpine:${envoy_version}"
  datacenter: ${datacenter_name}
  tls:
    enabled: true
    caCert:
      secretName: ${datacenter_name}-client-secrets
      secretKey: caCert
    caKey:
      secretName: ${datacenter_name}-client-secrets
      secretKey: caKey
  acls:
    manageSystemACLs: true
    bootstrapToken:
      secretName: ${datacenter_name}-client-secrets
      secretKey: token
  gossipEncryption:
    secretName: ${datacenter_name}-client-secrets
    secretKey: gossipEncryptionKey
  metrics:
    enabled: true
server:
  enabled: false
externalServers:
  enabled: true
  hosts:
    - "${server_address}"
  k8sAuthMethodHost: ${kubernetes_api_endpoint}
connectInject:
  enabled: true
  metrics:
    defaultEnableMerging: true
ingressGateways:
  enabled: true
  defaults:
    replicas: ${replicas}
    service:
      type: LoadBalancer
      ports:
        - port: 80
  gateways:
    - name: ${datacenter_name}-ingress-gateway