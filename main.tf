# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DEPLOY AND MANAGE A FUNCTION ON AWS LAMBDA
#
# This module takes a .zip file and uploads it to AWS Lambda
# to create a serverless function.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ------------------------------------------------------------------------------
# CREATE A LAMBDA FUNCTION
# ------------------------------------------------------------------------------

resource "aws_lambda_function" "lambda" {
  count = var.module_enabled ? 1 : 0

  function_name = var.function_name
  description   = var.description

  filename = var.filename
  runtime  = var.runtime
  handler  = var.handler
  publish  = var.publish
  role     = var.role_arn

  memory_size = var.memory_size
  timeout     = var.timeout

  dynamic environment {
    for_each = length(var.environment_variables) > 0 ? [true] : []

    content {
      variables = var.environment_variables
    }
  }

  tags = var.module_tags

  depends_on = [var.module_depends_on]
}
