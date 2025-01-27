resource "aws_iam_role" "lambda" {
  name = "${local.service_name}-${local.env}-${var.region}-lambdaRole"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "cloudwatch_logs" {
  name = "${local.service_name}-cloudwatch-logs"
  role = aws_iam_role.lambda.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogStream",
          "logs:CreateLogGroup",
          "logs:TagResource"
        ],
        "Resource" : [
          "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${local.service_name}-${local.env}*:*"
        ],
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:PutLogEvents"
        ],
        "Resource" : [
          "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${local.service_name}-${local.env}*:*:*"
        ],
      }
    ]
  })
}

resource "aws_iam_role_policy" "sns" {
  name = "${local.service_name}-sns"
  role = aws_iam_role.lambda.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "sns:Publish",
        ],
        "Resource" : [
          aws_sns_topic.alarm_topic.arn
        ]
      }
    ]
  })
}
