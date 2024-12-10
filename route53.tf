# Update Route 53 DNS settings
resource "aws_route53_record" "app_record" {
  zone_id = var.route53_zone_id
  name    = "${var.env}.${var.domain_name}"
  type    = "A"
  alias {
    evaluate_target_health = true
    name                   = aws_lb.app_lb.dns_name
    zone_id                = aws_lb.app_lb.zone_id
  }
}