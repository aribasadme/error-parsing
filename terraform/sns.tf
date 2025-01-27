resource "aws_sns_topic" "error_parsing_alerts" {
  name = var.sns_topic_name

  tags = {
    Environment            = local.env
    Product                = local.service_name
    Terraform              = "true"
    "Terraform Repository" = var.repository
  }
}
