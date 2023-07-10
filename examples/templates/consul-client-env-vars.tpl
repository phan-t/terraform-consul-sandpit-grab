CONSUL_HTTP_ADDR="127.0.0.1:8501"
CONSUL_HTTP_SSL=true
CONSUL_HTTP_TOKEN="${acl_token}"
CONSUL_CACERT="/opt/consul/tls/ca-cert.pem"
CONSUL_CLIENT_CERT="/opt/consul/tls/client-cert.pem"
CONSUL_CLIENT_KEY="/opt/consul/tls/client-key.pem"