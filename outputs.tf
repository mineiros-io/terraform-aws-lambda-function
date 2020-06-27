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

output "function_name" {
  description = "The unique name for the Lambda function."
  value       = var.function_name
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
  description = "The description of what the Lambda function does."
  value       = var.description
}

output "environment_variables" {
  description = "A map of environment variables to pass to the Lambda function. AWS will automatically encrypt these with KMS if a key is provided and decrypt them when running the function."
  value       = var.environment_variables
}

output "filename" {
  description = "The path to the .zip file that contains the Lambda function source code."
  value       = var.filename
}

output "function_tags" {
  description = "The map of tags that will be applied to the function."
  value       = var.function_name
}

output "memory_size" {
  description = "Amount of memory in MB the Lambda function can use at runtime."
  value       = var.memory_size
}

output "publish" {
  description = "Whether to publish creation/change as new Lambda function."
  value       = var.publish
}

output "role_arn" {
  description = "The ARN of the policy that is used to set the permissions boundary for the IAM role for the Lambda function."
  value       = var.role_arn
}

output "s3_bucket" {
  description = "The S3 bucket location containing the function's deployment package."
  value       = var.s3_bucket
}

output "s3_key" {
  description = "The S3 key of an object containing the function's deployment package."
  value       = var.s3_key
}

output "s3_object_version" {
  description = "The object version containing the function's deployment package."
  value       = var.s3_object_version
}

output "timeout" {
  description = "The amount of time the Lambda function has to run in seconds."
  value       = var.timeout
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
