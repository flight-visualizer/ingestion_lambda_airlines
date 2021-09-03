# Lambda Name: ingestion_lambda_airlines

#### Summary
Lambda to ingest top 100 airline data (iata codes) for reference by backend API

#### Architecture
![Architecture](https://github.com/flight-visualizer/ingestion_lambda_airlines/blob/master/images/ingestion_arch.png)

#### Deploy using Terraform

Navigate into the deploy directory and run terraform commands for deploying the cloudwatch event trigger, lambda, and IAM roles.

- `cd deploy`
- `terraform init`
- `terraform apply`