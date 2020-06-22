[<img src="https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg" width="400"/>][homepage]

[![license][badge-license]][apache20]
[![Terraform Version][badge-terraform]][releases-terraform]
[![Join Slack][badge-slack]][slack]

# Deploy a Python Function to AWS Lambda
 
This example shows how to deploy a Python Function to AWS Lambda.

## Basic usage

The code in [main.tf] shows how to deploy a Python function to AWS Lambda.
Since each Lambda Function requires an attached Execution Role, we also
deploy a new IAM Role and attach it to the function.

```hcl
module "terraform-aws-lambda-function" {
  source = "git@github.com:mineiros-io/terraform-aws-lambda-function.git?ref=v0.0.1"

  name        = "python-function"
  description = "Example Python Lambda Function that returns an HTTP response."
  lambda_path = "main.py.zip"
  runtime     = "python3.8"
  handler     = "main.lambda_handler"

  timeout     = 30
  memory_size = 128

  role_arn = aws_iam_role.lambda.arn

  tags = {
    Environment = "dev"
  }
}

# ------------------------------------------------------------------------------
# CREATE AN IAM ROLE THAT WILL BE ATTACHED TO THE LAMBDA FUNCTION
# ------------------------------------------------------------------------------

resource "aws_iam_role" "lambda" {
  name               = "python-function"
  assume_role_policy = data.aws_iam_policy_document.lambda_role.json

  tags = {
    Environment = "dev"
  }
}

data "aws_iam_policy_document" "lambda_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}
```

## Running the example

### Cloning the repository

``` bash
git clone https://github.com/mineiros-io/terraform-aws-lambda-function.git
cd terraform-aws-lambda-function/examples/example
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
<!-- markdown-link-check-disable -->
[main.tf]: https://github.com/mineiros-io/terraform-aws-lambda-function/blob/master/examples/python-function/main.tf
<!-- markdown-link-check-enable -->

[homepage]: https://mineiros.io/?ref=terraform-aws-lambda-function

[badge-license]: https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg
[badge-terraform]: https://img.shields.io/badge/terraform-0.13%20and%200.12.20+-623CE4.svg?logo=terraform
[badge-slack]: https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack

[releases-terraform]: https://github.com/hashicorp/terraform/releases
[apache20]: https://opensource.org/licenses/Apache-2.0
[slack]: https://join.slack.com/t/mineiros-community/shared_invite/zt-ehidestg-aLGoIENLVs6tvwJ11w9WGg
