global:
  enabled: false
  name: consul
  image: "hashicorp/consul-enterprise:${consul_version}-ent"
  imageK8S: "hashicorp/consul-k8s-control-plane:${consul_k8s_version}"
  imageEnvoy: "envoyproxy/envoy-alpine:${envoy_version}"
  datacenter: ${datacenter_name}
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
client:
  enabled: true
  join:
    - "${server_address}"
  exposeGossipPorts: true
  extraConfig: |
    {
      "acl": {
        "default_policy": "deny",
        "enable_token_persistence": true,
        "enabled": true,
        "tokens": {
          "default": "${acl_token}"
        }
      },
      "gossip_lan": {
        "gossip_interval": "1000ms",
        "probe_interval": "3s"
      },
      "telemetry": {
        "prometheus_retention_time": "72h"
      }
    } 
connectInject:
  enabled: true
  metrics:
    defaultEnableMerging: true
controller:
  enabled: true