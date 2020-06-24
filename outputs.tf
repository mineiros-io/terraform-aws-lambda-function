# ------------------------------------------------------------------------------
# OUTPUT CALCULATED VARIABLES (prefer full objects)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# OUTPUT ALL RESOURCES AS FULL OBJECTS
# ------------------------------------------------------------------------------

output "lambda_function" {
  description = "All outputs of the 'aws_lambda_function' resource."
  value       = try(aws_lambda_function.lambda[0], null)
}

# ------------------------------------------------------------------------------
# OUTPUT ALL INPUT VARIABLES
# ------------------------------------------------------------------------------

output "name" {
  description = "The unique name for the Lambda function."
  value       = var.description
}

output "handler" {
  description = "The function entrypoint in the code. This is the name of the method in the code which receives the event and context parameter when this Lambda function is triggered."
  value       = var.handler
}

output "runtime" {
  description = "The runtime the Lambda function should run in."
  value       = var.runtime
}

output "description" {
  description = "The Description of what the Lambda function does."
  value       = var.description
}

output "environment_variables" {
  description = "A map of environment variables to pass to the Lambda function. AWS will automatically encrypt these with KMS if a key is provided and decrypt them when running the function."
  value       = var.environment_variables
}

output "versioning" {
  description = "Whether to publish creation/change as new Lambda function."
  value       = var.versioning
}

output "memory_size" {
  description = "Amount of memory in MB the Lambda function can use at runtime."
  value       = var.memory_size
}

output "role_arn" {
  description = "The ARN of the policy that is used to set the permissions boundary for the IAM role for the Lambda function."
  value       = var.role_arn
}

output "lambda_path" {
  description = "The path to the .zip file that contains the Lambda function source code."
  value       = var.lambda_path
}

output "timeout" {
  description = "The amount of time the Lambda function has to run in seconds."
  value       = var.timeout
}

# ------------------------------------------------------------------------------
# OUTPUT MODULE CONFIGURATION
# ------------------------------------------------------------------------------

output "module_enabled" {
  description = "Whether the module is enabled."
  value       = var.module_enabled
}

output "module_defaults" {
  description = "Default settings that overwrite the module and resource defaults in this module."
  value       = var.module_defaults
}

output "module_tags" {
  description = "A map of tags that will be applied to all created resources that accept tags."
  value       = var.module_tags
}
