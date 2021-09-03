provider "aws" {
    region = "us-east-1"
}

# Create the lambda role
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

resource "aws_iam_role" "lambda_role" {
  name = "lambda_role"

  assume_role_policy = "${file("../iam/iam_role.json")}"
}

# Apply the Policy Document we just created
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda_policy"
  role = aws_iam_role.lambda_role.id
  policy = "${file("../iam/iam_policy.json")}"
}

# Create lambda function
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

module "lambda_zip" {
  source           = "github.com/ruzin/terraform_aws_lambda_python"
  output_path      = "lambda_function.zip"
  description      = "example for lambda module"
  source_code_path = "../src/"
  role_arn         = aws_iam_role.lambda_role.arn
  function_name    = "ingestion_lambda_airlines"
  handler_name     = "ingestion_lambda_airlines.lambda_handler"
  runtime          = "python3.6"
  environment = {
    API_KEY = "fea7d4c61d5cff92ae5823a3016bce40"
  }
}

# Run the function with CloudWatch Event rate scheduler
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

resource "aws_cloudwatch_event_rule" "event" {
    name = "event"
    description = "Fires once every month"
    schedule_expression = "rate(30 days)"
}

# Assign event to Lambda target
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

resource "aws_cloudwatch_event_target" "ingestion_lambda_target" {
    target_id = "event_rule"
    rule = aws_cloudwatch_event_rule.event.name
    arn = module.lambda_zip.arn
}

# Allow lambda to be called from cloudwatch
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

resource "aws_lambda_permission" "allow_cloudwatch" {
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    function_name = module.lambda_zip.function_name
    principal = "events.amazonaws.com"
    source_arn = aws_cloudwatch_event_rule.event.arn
}
