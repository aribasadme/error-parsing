resource "aws_lambda_permission" "cloudwatch_logs" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.error_parsing.function_name
  principal     = "logs.amazonaws.com"
  source_arn    = "${data.aws_cloudwatch_log_group.log_group.arn}:*"
}

resource "aws_lambda_function" "error_parsing" {
  function_name = "${local.service_name}-${local.env}-publish"
  description   = "Parses errors and sends to SNS topic."
  role          = aws_iam_role.lambda.arn
  handler       = "handler.run"
  runtime       = "python3.12"

  filename         = data.archive_file.lambda.output_path
  source_code_hash = data.archive_file.lambda.output_base64sha256

  depends_on = [
    aws_iam_role.lambda
  ]

  environment {
    variables = {
      LOG_LEVEL = "INFO",
      SNS_ARN   = aws_sns_topic.alarm_topic.arn
    }
  }

  tags = local.tf_common_tags
}
