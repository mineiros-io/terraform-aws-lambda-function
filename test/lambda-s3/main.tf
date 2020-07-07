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
  source_file = "${path.module}/../fixtures/python/main.py"
  output_path = "${path.module}/../fixtues/python/main.py.zip"
}

# ----------------------------------------------------------------------------------------------------------------------
# CREATE A S3 BUCKET AND UPLOAD THE ARCHIVE AS AN OBJECT
# ----------------------------------------------------------------------------------------------------------------------

module "s3_bucket" {
  source  = "mineiros-io/s3-bucket/aws"
  version = "~> 0.2.1"

  bucket        = var.s3_bucket_name
  force_destroy = var.s3_force_destroy
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
  source = "../.."

  function_name = var.function_name
  description   = var.description

  runtime  = var.runtime
  handler  = var.handler
  role_arn = module.iam_role.role.arn

  s3_bucket = aws_s3_bucket_object.function.bucket
  s3_key    = aws_s3_bucket_object.function.key

  timeout     = var.timeout
  memory_size = var.memory_size

  module_tags = var.module_tags
}

# ----------------------------------------------------------------------------------------------------------------------
# CREATE AN IAM ROLE THAT WILL BE ATTACHED TO THE LAMBDA FUNCTION
# ----------------------------------------------------------------------------------------------------------------------

module "iam_role" {
  source  = "mineiros-io/iam-role/aws"
  version = "0.0.2"

  name = var.function_name

  assume_role_principals = [
    {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  ]

  tags = var.module_tags
}
