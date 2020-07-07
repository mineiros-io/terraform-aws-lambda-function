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
  source_file = "${path.module}/../fixtures/python/main.py"
  output_path = "${path.module}/../fixtures/python/main.py.zip"
}

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
