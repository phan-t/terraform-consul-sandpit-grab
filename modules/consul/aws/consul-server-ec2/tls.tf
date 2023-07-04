// root certificate authority
resource "tls_private_key" "ca-key" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "tls_self_signed_cert" "ca-cert" {
  private_key_pem   = tls_private_key.ca-key.private_key_pem
  is_ca_certificate = true

  subject {
    common_name  = "Consul Root CA"
    organization = "HashiCorp"
  }

  validity_period_hours = 8760

  allowed_uses = [
    "cert_signing",
    "key_encipherment",
    "digital_signature"
  ]
}

// server certificate

resource "tls_private_key" "server-key" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "tls_cert_request" "server-cert" {
  private_key_pem = tls_private_key.server-key.private_key_pem

  subject {
    common_name  = "server.${local.datacenter_name}.consul"
    organization = "HashiCorp"
  }

  dns_names = [
    "${aws_instance.consul-server.private_dns}",
    "server.${local.datacenter_name}.consul",
    "${aws_instance.consul-server.private_dns}.server.${local.datacenter_name}.consul",
    "localhost"
  ]

  ip_addresses = [
    "${aws_instance.consul-server.private_ip}",
    "127.0.0.1",
  ]
}

resource "tls_locally_signed_cert" "server-signed-cert" {
  cert_request_pem = tls_cert_request.server-cert.cert_request_pem

  ca_private_key_pem = tls_private_key.ca-key.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.ca-cert.cert_pem

  allowed_uses = [
    "digital_signature",
    "key_encipherment"
  ]

  validity_period_hours = 8760
}

// ui certificate

resource "tls_private_key" "ui-key" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "tls_cert_request" "ui-cert" {
  private_key_pem = tls_private_key.ui-key.private_key_pem

  subject {
    common_name  = aws_route53_record.consul-ui.fqdn
    organization = "HashiCorp"
  }
}

resource "tls_locally_signed_cert" "ui-signed-cert" {
  cert_request_pem = tls_cert_request.ui-cert.cert_request_pem

  ca_private_key_pem = tls_private_key.ca-key.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.ca-cert.cert_pem

  allowed_uses = [
    "digital_signature",
    "key_encipherment"
  ]

  validity_period_hours = 8760
}

resource "aws_iam_server_certificate" "ui" {
  name             = "${var.deployment_id}-consul-ui"
  certificate_body = tls_locally_signed_cert.ui-signed-cert.cert_pem
  private_key      = tls_private_key.ui-key.private_key_pem
}

resource "local_file" "ca-key" {
  content  = tls_private_key.ca-key.private_key_pem
  filename = "${path.root}/tls/ca-key.pem"
}

resource "local_file" "ca-cert" {
  content  = tls_self_signed_cert.ca-cert.cert_pem
  filename = "${path.root}/tls/ca-cert.pem"
}

# resource "local_file" "server-cert" {
#   content  = tls_locally_signed_cert.server-signed-cert.cert_pem
#   filename = "${path.module}/tls/server-cert.pem"
# }

# resource "local_file" "server-key" {
#   content  = tls_private_key.server-key.private_key_pem
#   filename = "${path.module}/tls/server-key.pem"
# }

# resource "local_file" "ui-cert" {
#   content  = tls_locally_signed_cert.ui-signed-cert.cert_pem
#   filename = "${path.module}/tls/ui-cert.pem"
# }

# resource "local_file" "ui-key" {
#   content  = tls_private_key.ui-key.private_key_pem
#   filename = "${path.module}/tls/ui-key.pem"
# }