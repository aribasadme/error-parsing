data "aws_caller_identity" "current" {}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/../src/handler.py"
  output_path = "${path.module}/handler.zip"
}

data "aws_cloudwatch_log_group" "log_group" {
  name = var.log_group_name
}
