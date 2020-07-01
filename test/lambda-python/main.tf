# ----------------------------------------------------------------------------------------------------------------------
# PROVIDER CONFIGURATION
# ----------------------------------------------------------------------------------------------------------------------

provider "aws" {
  version = "~> 2.45"
  region  = var.aws_region
}

provider "archive" {
  version = "~> 1.3"
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/main.py"
  output_path = "${path.module}/main.py.zip"
}

module "lambda" {
  source = "../.."

  function_name = var.function_name
  description   = var.description

  runtime  = var.runtime
  handler  = var.handler
  role_arn = aws_iam_role.lambda.arn
  filename = data.archive_file.lambda.output_path

  timeout     = var.timeout
  memory_size = var.memory_size

  module_tags = var.module_tags
}


# ----------------------------------------------------------------------------------------------------------------------
# CREATE AN IAM ROLE THAT WILL BE ATTACHED TO THE LAMBDA FUNCTION
# ----------------------------------------------------------------------------------------------------------------------

resource "aws_iam_role" "lambda" {
  name               = var.function_name
  assume_role_policy = data.aws_iam_policy_document.lambda_role.json

  tags = var.module_tags
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
