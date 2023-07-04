export CONSUL_HTTP_ADDR="127.0.0.1:8501"
export CONSUL_HTTP_SSL=true
export CONSUL_HTTP_TOKEN="${acl_token}"
export CONSUL_CACERT="/opt/consul/tls/ca-cert.pem"
export CONSUL_CLIENT_CERT="/opt/consul/tls/client-cert.pem"
export CONSUL_CLIENT_KEY="/opt/consul/tls/client-key.pem"