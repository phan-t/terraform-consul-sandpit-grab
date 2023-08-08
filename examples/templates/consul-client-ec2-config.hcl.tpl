// general parameters

client_addr = "0.0.0.0"
bind_addr = "{{ GetPrivateInterfaces | include \"network\" \"10.0.0.0/8\" | attr \"address\" }}"
datacenter = "${datacenter_name}"
data_dir = "/opt/consul/data"
discovery_max_stale = "5s"
license_path = "/opt/consul/bin/consul-ent-license.hclic"
ports = {  dns = -1
  http = -1
  https = 8501
  grpc_tls = 8502
  serf_lan = 8301
  serf_wan = 8302
  server = 8300
}
primary_datacenter = "${datacenter_name}"
reconnect_timeout = "168h"
server = false

// acl parameters

acl = {
  enabled = true
  default_policy = "deny"
  enable_token_persistence = true
  tokens = {
    default = "${acl_token}"
  }
}

// service mesh parameters

connect = {
  enabled = true
}

// dns parameters

dns_config = {
  use_cache = true
  cache_max_age = "5s"
}

// encryption parameters

encrypt = "${gossip_encrypt_key}"

// join parameters

retry_join = ["${server_address}"]

// log parameters

log_json = true
enable_syslog = true

// node parameters

node_name = "${node_name}"

// tls configuration reference

verify_incoming = false
verify_outgoing = true
verify_server_hostname = true
ca_file = "/opt/consul/tls/ca-cert.pem"
cert_file = "/opt/consul/tls/client-cert.pem"
key_file = "/opt/consul/tls/client-key.pem"