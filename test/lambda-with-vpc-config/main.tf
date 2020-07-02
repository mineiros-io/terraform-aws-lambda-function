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

# ----------------------------------------------------------------------------------------------------------------------
# CREATE A DEPLOYMENT PACKAGE (.ZIP)
# ----------------------------------------------------------------------------------------------------------------------

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/main.py"
  output_path = "${path.module}/main.py.zip"
}

# ----------------------------------------------------------------------------------------------------------------------
# FETCH DEFAULT VPC DATA AND PASS TO THE LAMBDA FUNCTIONS VPC CONFIG
# ----------------------------------------------------------------------------------------------------------------------

resource "aws_default_vpc" "default" {
}

data "aws_subnet_ids" "default" {
  vpc_id = aws_default_vpc.default.id
}

resource "aws_default_security_group" "default" {
  vpc_id = aws_default_vpc.default.id
}

# ----------------------------------------------------------------------------------------------------------------------
# CREATE THE LAMBDA FUNCTION
# ----------------------------------------------------------------------------------------------------------------------

module "lambda" {
  source = "../.."

  function_name = var.function_name
  description   = var.description

  runtime  = var.runtime
  handler  = var.handler
  role_arn = module.iam_role.role.arn
  filename = data.archive_file.lambda.output_path

  timeout     = var.timeout
  memory_size = var.memory_size

  vpc_subnet_ids         = data.aws_subnet_ids.default.ids
  vpc_security_group_ids = [aws_default_security_group.default.id]

  module_tags = var.module_tags
}

# ----------------------------------------------------------------------------------------------------------------------
# CREATE AN IAM ROLE THAT WILL BE ATTACHED TO THE LAMBDA FUNCTION
# ----------------------------------------------------------------------------------------------------------------------

module "iam_role" {
  source  = "mineiros-io/iam-role/aws"
  version = "0.0.2"

  assume_role_policy = data.aws_iam_policy_document.lambda_role.json

  tags = var.module_tags
}

data "aws_iam_policy_document" "lambda_role" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# ----------------------------------------------------------------------------------------------------------------------
# CREATE AN IAM POLICY THAT ALLOWS LAMBDA TO MANAGE NETWORK INTERFACES
# ----------------------------------------------------------------------------------------------------------------------

# See also the following AWS managed policy: AWSLambdaBasicExecutionRole
# TODO: Should be replaced with AWSLambdaVPCAccessExecutionRole ?
# https://docs.aws.amazon.com/lambda/latest/dg/lambda-intro-execution-role.html
module "lambda_vpc_iam_policy" {
  source  = "mineiros-io/iam-policy/aws"
  version = "0.0.2"

  name        = "LambdaVPCAccess"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = data.aws_iam_policy_document.lambda_vpc.json
}

data "aws_iam_policy_document" "lambda_vpc" {
  statement {
    effect = "Allow"

    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DetachNetworkInterface",
      "ec2:DeleteNetworkInterface",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy_attachment" "lambda_vpc" {
  role       = module.iam_role.role.name
  policy_arn = module.lambda_vpc_iam_policy.policy.arn
}
