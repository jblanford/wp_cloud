# Lookup the route53 zone id for our domain
data "aws_route53_zone" "selected" {
  name = var.dns_zone
}

# Add an alias record for our alb
resource "aws_route53_record" "web" {
  zone_id = data.aws_route53_zone.selected.zone_id
  # use the project name and environment ot make the host a record
  name = "${var.project_name}-${var.environment}.${data.aws_route53_zone.selected.name}"
  type = "A"

  alias {
    name                   = aws_lb.web-alb.dns_name
    zone_id                = aws_lb.web-alb.zone_id
    evaluate_target_health = true
  }
}

# Output the new dns entry
output "hostname" {
  value       = aws_route53_record.web.fqdn
  description = "DNS hostname for this project"
}
