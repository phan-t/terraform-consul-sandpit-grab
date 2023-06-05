data "aws_route53_zone" "hashidemos" {
  name         = "${var.route53_sandbox_prefix}.sbx.hashidemos.io."
  private_zone = false
}

resource "aws_route53_record" "consul-ui" {
  zone_id = data.aws_route53_zone.hashidemos.zone_id
  name    = var.deployment_id
  type    = "CNAME"
  ttl     = 300
  records = [aws_lb.consul-ui.dns_name]
}