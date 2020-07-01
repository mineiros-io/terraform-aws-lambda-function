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
# CREATE A ZIP ARCHIVE FROM SOURCES
# ----------------------------------------------------------------------------------------------------------------------

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/main.py"
  output_path = "${path.module}/main.py.zip"
}

# ----------------------------------------------------------------------------------------------------------------------
# CREATE A S3 BUCKET AND UPLOAD THE ARCHIVE AS AN OBJECT
# ----------------------------------------------------------------------------------------------------------------------

resource "aws_s3_bucket" "lambda" {
  bucket        = var.s3_bucket_name
  acl           = "private"
  force_destroy = var.s3_force_destroy
}

resource "aws_s3_bucket_object" "function" {
  bucket = aws_s3_bucket.lambda.bucket
  key    = "main.py.zip"
  source = data.archive_file.lambda.output_path
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
  role_arn = aws_iam_role.lambda.arn

  s3_bucket = var.s3_bucket_name
  s3_key    = var.s3_object_key

  timeout     = var.timeout
  memory_size = var.memory_size

  module_tags = var.module_tags

  module_depends_on = [aws_s3_bucket_object.function]
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
