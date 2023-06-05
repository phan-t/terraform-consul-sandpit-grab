// general parameters

client_addr = "0.0.0.0"
autopilot = {
  min_quorum = ${quorum_size}
}
bind_addr = "{{ GetPrivateInterfaces | include \"network\" \"10.0.0.0/8\" | attr \"address\" }}"
datacenter = "${datacenter_name}"
data_dir = "/opt/consul/data"
discovery_max_stale = "5s"
license_path = "/opt/consul/bin/consul-ent-license.hclic"
performance = {
  raft_multiplier = 2
}
ports = {
  dns = -1
  http = -1
  https = 8501
  serf_lan = 8301
  serf_wan = 8302
  server = 8300
}
primary_datacenter = "${datacenter_name}"
reconnect_timeout = "168h"
server = true

// acl parameters

acl = {
  enabled = true
  default_policy = "allow"
  enable_token_persistence = true
  tokens = {
    master = "${initial_acl_token}"
    agent = "${initial_acl_token}"
  }
}

// bootstrap parameters

bootstrap_expect = ${quorum_size}

// service mesh parameters

connect = {
  enabled = true
  ca_provider = "consul"
  ca_config = {
    csr_max_concurrent = 1
    leaf_cert_ttl = "336h"
  }
}

// dns parameters

dns_config = {
  use_cache = true
  cache_max_age = "5s"
}

// encryption parameters

encrypt = "${gossip_encrypt_key}"

// log parameters

log_json = true
enable_syslog = true

// node parameters

node_name = "${node_name}"

// ui parameters

ui_config = {
  enabled = true
}

// tls configuration reference

verify_incoming = false
verify_outgoing = true
verify_server_hostname = true
ca_file = "/opt/consul/tls/ca-cert.pem"
cert_file = "/opt/consul/tls/server-cert.pem"
key_file = "/opt/consul/tls/server-key.pem"
server_name = "${node_name}"
