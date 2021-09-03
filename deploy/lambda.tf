

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