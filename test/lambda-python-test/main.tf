# ------------------------------------------------------------------------------
# PROVIDER CONFIGURATION
# ------------------------------------------------------------------------------

provider "aws" {
  version = "~> 2.45"
  region  = var.aws_region
}

module "lambda" {
  source = "../.."

  name = var.name

  runtime  = var.runtime
  handler  = var.handler
  role_arn = aws_iam_role.lambda.arn

  lambda_path = var.lambda_path

  timeout     = var.timeout
  memory_size = var.memory_size


  tags = var.tags
}


# ------------------------------------------------------------------------------
# CREATE AN IAM ROLE THAT WILL BE ATTACHED TO THE LAMBDA FUNCTION
# ------------------------------------------------------------------------------

resource "aws_iam_role" "lambda" {
  name                 = var.name
  assume_role_policy   = data.aws_iam_policy_document.lambda_role.json
  permissions_boundary = var.lambda_role_permissions_boundary_arn

  tags = var.tags
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
