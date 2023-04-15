variable "route53_zone_name" {
  type        = string
  description = "dev.yanbiyu.me"
}

data "aws_route53_zone" "selected" {
  name         = var.route53_zone_name
  private_zone = false
}

resource "aws_route53_record" "record" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = data.aws_route53_zone.selected.name
  type    = "A"
  alias {
    name                   = aws_lb.lb.dns_name
    zone_id                = aws_lb.lb.zone_id
    evaluate_target_health = true
  }
}