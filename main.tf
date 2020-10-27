# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DEPLOY AND MANAGE A FUNCTION ON AWS LAMBDA
# This module takes a .zip file and uploads it to AWS Lambda
# to create a serverless function.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

locals {
  s3_bucket         = var.filename != null ? null : var.s3_bucket
  s3_key            = var.filename != null ? null : var.s3_key
  s3_object_version = var.filename != null ? null : var.s3_object_version

  source_code_hash = var.source_code_hash != null ? var.source_code_hash : var.filename != null ? filebase64sha256(var.filename) : null
}

# ----------------------------------------------------------------------------------------------------------------------
# CREATE A LAMBDA FUNCTION
# ----------------------------------------------------------------------------------------------------------------------

resource "aws_lambda_function" "lambda" {
  count = var.module_enabled ? 1 : 0

  function_name = var.function_name
  description   = var.description

  filename         = var.filename
  source_code_hash = local.source_code_hash

  s3_bucket         = local.s3_bucket
  s3_key            = local.s3_key
  s3_object_version = local.s3_object_version

  runtime = var.runtime
  handler = var.handler
  layers  = var.layer_arns
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

  vpc_config {
    security_group_ids = var.vpc_security_group_ids
    subnet_ids         = var.vpc_subnet_ids
  }

  dynamic tracing_config {
    for_each = var.tracing_mode != null ? [true] : []

    content {
      mode = var.tracing_mode
    }
  }

  tags = merge(var.module_tags, var.function_tags)

  depends_on = [var.module_depends_on]
}

# ----------------------------------------------------------------------------------------------------------------------
# CREATE A MAP OF ALIASES FOR THE LAMBDA FUNCTION
# ----------------------------------------------------------------------------------------------------------------------

locals {
  aliases = {
    for name, config in var.aliases : name => {
      description                = try(config.description, ""),
      version                    = try(config.version, "$LATEST")
      additional_version_weights = try(config.additional_version_weights, {})
    }
  }
}

resource "aws_lambda_alias" "alias" {
  for_each = var.module_enabled ? local.aliases : {}

  name             = each.key
  description      = each.value.description
  function_name    = aws_lambda_function.lambda[0].function_name
  function_version = each.value.version

  dynamic routing_config {
    for_each = length(each.value.additional_version_weights) > 0 ? [true] : []

    content {
      additional_version_weights = each.value.additional_version_weights
    }
  }
}

# ----------------------------------------------------------------------------------------------------------------------
# ATTACH A MAP OF PERMISSIONS TO THE LAMBDA FUNCTION
# ----------------------------------------------------------------------------------------------------------------------

locals {
  permissions = {
    for idx, permission in var.permissions : permission.statement_id => idx
  }
}

resource "aws_lambda_permission" "permission" {
  for_each = var.module_enabled ? local.permissions : {}

  function_name = aws_lambda_function.lambda[0].function_name

  # required
  statement_id = each.key
  principal    = var.permissions[each.value].principal
  source_arn   = var.permissions[each.value].source_arn

  # optional with fixed default
  action = try(var.permissions[each.value].action, "lambda:InvokeFunction")

  # optional
  event_source_token = try(var.permissions[each.value].event_source_token, null)
  qualifier          = try(var.permissions[each.value].qualifier, null)
  source_account     = try(var.permissions[each.value].source_account, null)
}
