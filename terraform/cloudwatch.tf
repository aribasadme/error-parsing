resource "aws_cloudwatch_log_subscription_filter" "log_filter" {
  name            = "error-filter"
  log_group_name  = data.aws_cloudwatch_log_group.log_group.name
  filter_pattern  = "[ERROR]"
  destination_arn = aws_lambda_function.error_parsing.arn
}
