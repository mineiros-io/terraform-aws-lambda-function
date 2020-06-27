# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DEPLOY A PYTHON FUNCTION TO AWS LAMBDA
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ----------------------------------------------------------------------------------------------------------------------
# EXAMPLE AWS PROVIDER SETUP
# ----------------------------------------------------------------------------------------------------------------------

provider "aws" {
  version = "~> 2.0"
  region  = "us-east-1"
}

# ----------------------------------------------------------------------------------------------------------------------
# AWS LAMBDA EXPECTS A DEPLOYMENT PACKAGE
# A deployment package is a ZIP archive that contains your function code and dependencies.
# ----------------------------------------------------------------------------------------------------------------------

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/python/main.py"
  output_path = "${path.module}/python/main.py.zip"
}

# ----------------------------------------------------------------------------------------------------------------------
# DEPLOY THE LAMBDA FUNCTION
# ----------------------------------------------------------------------------------------------------------------------

module "terraform-aws-lambda-function" {
  source = "git@github.com:mineiros-io/terraform-aws-lambda-function.git?ref=v0.0.1"

  function_name = "python-function"
  description   = "Example Python Lambda function that returns an HTTP response."
  filename      = data.archive_file.lambda.output_path
  runtime       = "python3.8"
  handler       = "main.lambda_handler"

  timeout     = 30
  memory_size = 128

  role_arn = aws_iam_role.lambda.arn

  module_tags = {
    Environment = "dev"
  }
}

# ----------------------------------------------------------------------------------------------------------------------
# CREATE AN IAM LAMBDA EXECUTION ROLE WHICH WILL BE ATTACHED TO THE FUNCTION
# ----------------------------------------------------------------------------------------------------------------------

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
