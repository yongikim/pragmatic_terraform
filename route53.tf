data "aws_route53_zone" "yongikim" {
  name = "yongikim.com"
}

resource "aws_route53_record" "yongikim" {
  zone_id = data.aws_route53_zone.yongikim.zone_id
  name    = data.aws_route53_zone.yongikim.name
  type    = "A"

  alias {
    name                   = aws_lb.example.dns_name
    zone_id                = aws_lb.example.zone_id
    evaluate_target_health = true
  }
}
