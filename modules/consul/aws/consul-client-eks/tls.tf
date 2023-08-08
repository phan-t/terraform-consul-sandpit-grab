// client certificate

resource "tls_private_key" "client-key" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "tls_cert_request" "client-cert" {
  private_key_pem = tls_private_key.client-key.private_key_pem

  subject {
    common_name  = "k8s.${local.datacenter_name}.consul"
    organization = "HashiCorp"
  }

  ip_addresses = [
    "127.0.0.1",
  ]
}

resource "tls_locally_signed_cert" "client-signed-cert" {
  cert_request_pem = tls_cert_request.client-cert.cert_request_pem

  ca_private_key_pem = var.ca_key
  ca_cert_pem        = var.ca_cert

  allowed_uses = [
    "digital_signature",
    "key_encipherment"
  ]

  validity_period_hours = 8760
}