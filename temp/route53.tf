data "aws_route53_zone" "selected" {
  name         = "dev.yanbiyu.me"
  private_zone = false
}

resource "aws_route53_record" "record" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = data.aws_route53_zone.selected.name
  type    = "A"
  ttl     = 60
  records = [aws_instance.webapp_instance.public_ip]
}