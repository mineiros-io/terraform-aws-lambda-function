# ----------------------------------------------------------------------------------------------------------------------
# OUTPUT CALCULATED VARIABLES (prefer full objects)
# ----------------------------------------------------------------------------------------------------------------------

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

locals {
  region       = data.aws_region.current.name
  account_id   = data.aws_caller_identity.current.account_id
  function_arn = "arn:aws:lambda:${local.region}:${local.account_id}:function:${var.function_name}"
}

output "guessed_function_arn" {
  description = "Guessed function arn in the format: arn:aws:lambda:<region>:<account_id>:function:<function_name>"
  value       = local.function_arn
}

# ----------------------------------------------------------------------------------------------------------------------
# OUTPUT ALL RESOURCES AS FULL OBJECTS
# ----------------------------------------------------------------------------------------------------------------------

output "function" {
  description = "All outputs of the 'aws_lambda_function' resource."
  value       = try(aws_lambda_function.lambda[0], null)
}

output "aliases" {
  description = "A map of all created 'aws_lambda_alias' resources keyed by name."
  value       = try(aws_lambda_alias.alias, null)
}

output "permissions" {
  description = "A map of all created 'aws_lambda_permission' resources keyed by statement_id."
  value       = try(aws_lambda_permission.permission, null)
}

# ----------------------------------------------------------------------------------------------------------------------
# OUTPUT ALL INPUT VARIABLES
# ----------------------------------------------------------------------------------------------------------------------

output "module_inputs" {
  description = "A map of all module arguments. Omitted optional arguments will be represented with their actual defaults."
  value = {
    aliases                        = local.aliases
    dead_letter_config_target_arn  = var.dead_letter_config_target_arn
    description                    = var.description
    environment_variables          = var.environment_variables
    filename                       = var.filename
    function_tags                  = var.function_tags
    function_name                  = var.function_name
    handler                        = var.handler
    kms_key_arn                    = var.kms_key_arn
    layer_arns                     = var.layer_arns
    memory_size                    = var.memory_size
    permissions                    = values(local.permissions)
    publish                        = var.publish
    reserved_concurrent_executions = var.reserved_concurrent_executions
    runtime                        = var.runtime
    role_arn                       = var.role_arn
    s3_bucket                      = local.s3_bucket
    s3_key                         = local.s3_key
    s3_object_version              = local.s3_object_version
    source_code_hash               = local.source_code_hash
    timeout                        = var.timeout
    tracing_mode                   = var.tracing_mode
    vpc_subnet_ids                 = var.vpc_subnet_ids
    vpc_security_group_ids         = var.vpc_security_group_ids
  }
}

# ----------------------------------------------------------------------------------------------------------------------
# OUTPUT MODULE CONFIGURATION
# ----------------------------------------------------------------------------------------------------------------------

output "module_enabled" {
  description = "Whether the module is enabled."
  value       = var.module_enabled
}

output "module_tags" {
  description = "The map of tags that will be applied to all created resources that accept tags."
  value       = var.module_tags
}
