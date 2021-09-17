# ----------------------------------------------------------------------------------------------------------------------
# PROVIDER CONFIGURATION
# ----------------------------------------------------------------------------------------------------------------------

provider "aws" {
  region = var.aws_region
}

# ----------------------------------------------------------------------------------------------------------------------
# PREPARE THE DEPLOYMENT PACKAGE
# ----------------------------------------------------------------------------------------------------------------------

terraform {
  required_providers {
    archive = "~> 1.3"
  }
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/../fixtures/python/main.py"
  output_path = "${path.module}/../fixtures/python/main.py.zip"
}

# ----------------------------------------------------------------------------------------------------------------------
# FETCH DEFAULT VPC DATA AND PASS TO THE LAMBDA FUNCTIONS VPC CONFIG
# ----------------------------------------------------------------------------------------------------------------------

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

resource "aws_default_security_group" "default" {
  vpc_id = data.aws_vpc.default.id
}

# ----------------------------------------------------------------------------------------------------------------------
# DEPLOY THE LAMBDA FUNCTION
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

  aliases = {
    latest = {}
  }

  permissions = [
    {
      statement_id = "AllowExecutionFromSNS"
      principal    = "sns.amazonaws.com"
      source_arn   = aws_sns_topic.lambda.arn
    }
  ]

  module_tags = var.module_tags
}

# ----------------------------------------------------------------------------------------------------------------------
# CREATE A SNS TOPIC AND SUBSCRIBE THE LAMBDA FUNCTION
# ----------------------------------------------------------------------------------------------------------------------

resource "aws_sns_topic" "lambda" {
  name = "call-lambda-maybe"
}

resource "aws_sns_topic_subscription" "lambda" {
  topic_arn = aws_sns_topic.lambda.arn
  protocol  = "lambda"
  endpoint  = module.lambda.function.arn
}

# ----------------------------------------------------------------------------------------------------------------------
# CREATE AN IAM ROLE THAT WILL BE ATTACHED TO THE LAMBDA FUNCTION
# ----------------------------------------------------------------------------------------------------------------------

module "iam_role" {
  source  = "mineiros-io/iam-role/aws"
  version = "~> 0.6.0"

  name = var.function_name

  assume_role_principals = [
    {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  ]

  policy_statements = [
    {
      sid = "LambdaVPCAccess"

      actions = [
        "ec2:CreateNetworkInterface",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DetachNetworkInterface",
        "ec2:DeleteNetworkInterface",
      ]
      resources = ["*"]
    }
  ]

  tags = var.module_tags
}
