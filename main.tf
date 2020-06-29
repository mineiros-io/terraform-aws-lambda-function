# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DEPLOY AND MANAGE A FUNCTION ON AWS LAMBDA
# This module takes a .zip file and uploads it to AWS Lambda
# to create a serverless function.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ----------------------------------------------------------------------------------------------------------------------
# CREATE A LAMBDA FUNCTION
# ----------------------------------------------------------------------------------------------------------------------

resource "aws_lambda_function" "lambda" {
  count = var.module_enabled ? 1 : 0

  function_name = var.function_name
  description   = var.description

  filename = var.filename

  s3_bucket         = var.s3_bucket
  s3_key            = var.s3_key
  s3_object_version = var.s3_object_version

  runtime = var.runtime
  handler = var.handler
  layers  = var.layers
  publish = var.publish
  role    = var.role_arn

  memory_size = var.memory_size
  timeout     = var.timeout

  reserved_concurrent_executions = var.reserved_concurrent_executions

  kms_key_arn = var.kms_key_arn

  dynamic environment {
    for_each = length(var.environment_variables) > 0 ? [true] : []

    content {
      variables = var.environment_variables
    }
  }

  dynamic dead_letter_config {
    for_each = length(var.dead_letter_config_target_arn) > 0 ? [true] : []

    content {
      target_arn = var.dead_letter_config_target_arn
    }
  }

  dynamic vpc_config {
    for_each = length(var.vpc_subnet_ids) > 0 && length(var.vpc_security_group_ids)  > 0 ? [true] : []

    content {
      security_group_ids = var.vpc_security_group_ids
      subnet_ids         = var.vpc_security_group_ids
    }
  }

  tags = merge(var.module_tags, var.function_tags)

  depends_on = [var.module_depends_on]
}
