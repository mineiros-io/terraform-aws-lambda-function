[<img src="https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg" width="400"/>][homepage]

[![license][badge-license]][apache20]
[![Terraform Version][badge-terraform]][releases-terraform]
[![Join Slack][badge-slack]][slack]

# Deploy a Python Deployment Package that is located in S3 to AWS Lambda

## Basic usage

The code in [main.tf] shows how to deploy a deployment package that is located
in S3 to AWS Lambda. Since each Lambda function requires an attached Execution Role, we also
deploy a new IAM Role and attach it to the function. The configuration creates an
alias, VPC config and permissions also.
For details please see the code in the [main.tf] file.

```hcl
module "lambda" {
  source  = "mineiros-io/lambda-function/aws"
  version = "~> 0.1.0"

  function_name = "mineiros-s3-lambda-example"
  description   = "This is a simple Lambda Function that has its deployment package located in a S3 bucket."

  runtime  = "python3.8"
  handler  = "min.lambda_handler"
  role_arn = module.iam_role.role.arn
  publish  = true

  s3_bucket = aws_s3_bucket_object.function.bucket
  s3_key    = aws_s3_bucket_object.function.key

  timeout     = 3
  memory_size = 128

  vpc_subnet_ids         = data.aws_subnet_ids.default.ids
  vpc_security_group_ids = [aws_default_security_group.default.id]

  aliases = {
    latest = {
      description = "The latest deployed version."
    }
  }

  permissions = [
    {
      statement_id = "AllowExecutionFromSNS"
      principal    = "sns.amazonaws.com"
      source_arn   = aws_sns_topic.lambda.arn
    }
  ]

  module_tags = {
    Environment = "Test"
  }
}
```

## Running the example

### Cloning the repository

``` bash
git clone https://github.com/mineiros-io/terraform-aws-lambda-function.git
cd terraform-aws-lambda-function/examples/s3-complete-example
```

### Initializing Terraform

Run `terraform init` to initialize the example and download providers and the module.

### Planning the example

Run `terraform plan` to see a plan of the changes.

### Applying the example

Run `terraform apply` to create the resources.
You will see a plan of the changes and Terraform will prompt you for approval to actually apply the changes.

### Destroying the example

Run `terraform destroy` to destroy all resources again.

<!-- References -->

[main.tf]: https://github.com/mineiros-io/terraform-aws-lambda-function/blob/master/examples/s3-complete-example/main.tf
[homepage]: https://mineiros.io/?ref=terraform-aws-lambda-function
[badge-license]: https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg
[badge-terraform]: https://img.shields.io/badge/terraform-0.13%20and%200.12.20+-623CE4.svg?logo=terraform
[badge-slack]: https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack
[releases-terraform]: https://github.com/hashicorp/terraform/releases
[apache20]: https://opensource.org/licenses/Apache-2.0
[slack]: https://join.slack.com/t/mineiros-community/shared_invite/zt-ehidestg-aLGoIENLVs6tvwJ11w9WGg
