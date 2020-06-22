# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DEPLOY AND MANAGE A FUNCTION ON AWS LAMBDA
#
# This module takes a .zip file and uploads it to AWS Lambda
# to create a serverless function.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

locals {
  tags = merge({ Name = var.name }, var.module_tags)
}

# ------------------------------------------------------------------------------
# CREATE A LAMBDA FUNCTION
# ------------------------------------------------------------------------------

resource "aws_lambda_function" "lambda" {
  count = var.module_enabled ? 1 : 0

  function_name = var.name
  description   = var.description

  filename = var.lambda_path
  runtime  = var.runtime
  handler  = var.handler
  publish  = var.versioning
  role     = var.role_arn

  memory_size = var.memory_size
  timeout     = var.timeout

  dynamic environment {
    for_each = length(var.environment_variables) > 0 ? [true] : []

    content {
      variables = var.environment_variables
    }
  }

  tags = local.tags

  depends_on = [var.module_depends_on]
}
