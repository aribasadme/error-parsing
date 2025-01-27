resource "aws_sns_topic" "alarm_topic" {
  name = var.sns_topic_name

  tags = {
    Environment            = local.env
    Product                = local.service_name
    Terraform              = "true"
    "Terraform Repository" = var.repository
  }
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.alarm_topic.arn
  protocol  = "email"
  endpoint  = var.email
}
