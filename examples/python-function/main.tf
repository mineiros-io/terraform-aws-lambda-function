# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DEPLOY A PYTHON FUNCTION TO AWS LAMBDA
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ------------------------------------------------------------------------------
# EXAMPLE AWS PROVIDER SETUP
# ------------------------------------------------------------------------------

provider "aws" {
  version = "~> 2.0"
  region  = "us-east-1"
}

# ------------------------------------------------------------------------------
# DEPLOY THE LAMBDA FUNCTION
# ------------------------------------------------------------------------------

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
