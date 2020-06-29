# ----------------------------------------------------------------------------------------------------------------------
# OUTPUT CALCULATED VARIABLES (prefer full objects)
# ----------------------------------------------------------------------------------------------------------------------

# ----------------------------------------------------------------------------------------------------------------------
# OUTPUT ALL RESOURCES AS FULL OBJECTS
# ----------------------------------------------------------------------------------------------------------------------

output "function" {
  description = "All outputs of the 'aws_lambda_function' resource."
  value       = try(aws_lambda_function.lambda[0], null)
}

# ----------------------------------------------------------------------------------------------------------------------
# OUTPUT ALL INPUT VARIABLES
# ----------------------------------------------------------------------------------------------------------------------

output "module_inputs" {
  description = "A map of all module arguments."
  value = {
    description           = var.description
    environment_variables = var.environment_variables
    filename              = var.filename
    function_tags         = var.function_tags
    function_name         = var.function_name
    handler               = var.handler
    memory_size           = var.memory_size
    publish               = var.publish
    runtime               = var.runtime
    role_arn              = var.role_arn
    s3_bucket             = var.s3_bucket
    s3_key                = var.s3_key
    s3_object_version     = var.s3_object_version
    timeout               = var.timeout
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
