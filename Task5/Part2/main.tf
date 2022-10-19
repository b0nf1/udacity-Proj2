provider "aws" {
  region  = var.aws_east1
    shared_config_files = [ "/home/bonfi/.aws/config" ]
    shared_credentials_files = [ "/home/bonfi/.aws/credentials" ]
}

data "archive_file" "archive" {
  type        = "zip"
  source_file = var.py_source
  output_path = var.output_path
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "greet_lambda" {
  filename      = "${var.lambda_f_name}.zip"
  function_name = "greet_lambda"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "greet_lambda.lambda_handler"

  source_code_hash = data.archive_file.archive.output_base64sha256

  runtime = "python3.8"

  environment {
    variables = {
      greeting = "Hello from lambda!"
    }
  }
depends_on = [aws_iam_role_policy_attachment.lambda_logs, aws_cloudwatch_log_group.lambda_log_group]
}

resource "aws_iam_policy" "lambda_logging" {
  name        = "lambda_logging"
  path        = "/"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}

resource "aws_cloudwatch_log_group" "lambda_log_group" {
    name = "/aws/lambda/${var.lambda_f_name}"
    retention_in_days = 3
}
