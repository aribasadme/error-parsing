resource "aws_cloudwatch_log_group" "log_group" {
  name = var.log_group_name
}

resource "aws_cloudwatch_log_subscription_filter" "log_filter" {
  name            = "error-filter"
  depends_on      = [aws_lambda_permission.cloudwatch_logs]
  log_group_name  = aws_cloudwatch_log_group.log_group.name
  filter_pattern  = "[ERROR]"
  destination_arn = aws_lambda_function.error_parsing.arn
}
