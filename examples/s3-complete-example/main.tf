# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# S3 COMPLETE EXAMPLE
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ----------------------------------------------------------------------------------------------------------------------
# PROVIDER CONFIGURATION
# ----------------------------------------------------------------------------------------------------------------------

provider "aws" {
  region = "us-east-1"
}

terraform {
  required_providers {
    archive = "~> 1.3"
  }
}

# ----------------------------------------------------------------------------------------------------------------------
# CREATE A ZIP ARCHIVE FROM SOURCES
# ----------------------------------------------------------------------------------------------------------------------

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/python/main.py"
  output_path = "${path.module}/python/main.py.zip"
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
# CREATE A S3 BUCKET AND UPLOAD THE ARCHIVE AS AN OBJECT
# ----------------------------------------------------------------------------------------------------------------------

module "s3_bucket" {
  source  = "mineiros-io/s3-bucket/aws"
  version = "~> 0.5.0"

  bucket_prefix = "mineiros-s3-example-"
  force_destroy = true
}

resource "aws_s3_bucket_object" "function" {
  bucket = module.s3_bucket.id
  key    = "main.py.zip"
  source = data.archive_file.lambda.output_path
}

# ----------------------------------------------------------------------------------------------------------------------
# CREATE THE LAMBDA FUNCTION
# ----------------------------------------------------------------------------------------------------------------------

module "lambda" {
  source  = "mineiros-io/lambda-function/aws"
  version = "~> 0.4.0"

  function_name = "mineiros-s3-lambda-example"
  description   = "This is a simple Lambda Function that has its deployment package located in a S3 bucket."

  runtime  = "python3.8"
  handler  = "main.lambda_handler"
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
# The Lambda Function needs access to the VPC if you'd to grant it permission
# to a VPC.
# ----------------------------------------------------------------------------------------------------------------------

module "iam_role" {
  source  = "mineiros-io/iam-role/aws"
  version = "~> 0.5.0"

  name = "mineiros-s3-lambda-example"

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

  tags = {
    Environment = "Test"
  }
}
