# Specify the provider and access details
provider "aws" {
  region = "$us-east-1"
}

provider "archive" {}

data "archive_file" "zip" {
  type        = "zip"
  source_file = "lambda_handler.py"
  output_path = "lambda_handler.zip"
}

data "aws_iam_policy_document" "policy" {
  name = "api_lambda_flights_iam_policy"
  statement {
    sid    = ""
    effect = "Allow"

    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = "${data.aws_iam_policy_document.policy.json}"
}

resource "aws_lambda_function" "lambda" {

  filename = "${data.archive_file.zip.output_path}"
  function_name = "api_lambda_flights"
  role    = aws_iam_role.iam_for_lambda.arn
  handler = "lambda_handler.handler"
  runtime = "python3.6"

  environment {
    variables = {
      API_KEY = "fea7d4c61d5cff92ae5823a3016bce40"
    }
  }
}
