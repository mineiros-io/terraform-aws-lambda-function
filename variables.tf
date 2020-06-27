# ----------------------------------------------------------------------------------------------------------------------
# ENVIRONMENT VARIABLES
# Define these secrets as environment variables.
# ----------------------------------------------------------------------------------------------------------------------

# AWS_ACCESS_KEY_ID
# AWS_SECRET_ACCESS_KEY

# ----------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These variables must be set when using this module.
# ----------------------------------------------------------------------------------------------------------------------

variable "function_name" {
  description = "(Required) A unique name for the Lambda function."
  type        = string
}

variable "handler" {
  description = "(Required) The function entrypoint in the code. This is the name of the method in the code which receives the event and context parameter when this Lambda function is triggered."
  type        = string
}

variable "runtime" {
  description = "(Required) The runtime the Lambda function should run in. A list of all available runtimes can be found here: https://docs.aws.amazon.com/lambda/latest/dg/lambda-runtimes.html"
  type        = string
}

# ----------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These variables have defaults, but may be overridden.
# ----------------------------------------------------------------------------------------------------------------------

variable "description" {
  type        = string
  description = "(Optional) A description of what the Lambda function does."
  default     = null
}

variable "environment_variables" {
  description = "(Optional) A map of environment variables to pass to the Lambda function. AWS will automatically encrypt these with KMS if a key is provided and decrypt them when running the function."
  type        = map(string)
  default     = {}
}

variable "publish" {
  type        = bool
  description = "(Optional) Whether to publish creation/change as new Lambda function. This allows you to use aliases to refer to execute different versions of the function in different environments. Note that an alternative way to run Lambda functions in multiple environments is to version the Terraform code."
  default     = false
}

variable "memory_size" {
  description = "(Optional) Amount of memory in MB the Lambda function can use at runtime. For details see https://docs.aws.amazon.com/lambda/latest/dg/gettingstarted-limits.html"
  type        = number
  default     = 128
}

variable "role_arn" {
  description = "(Optional) The ARN of the policy that is used to set the permissions boundary for the IAM role for the Lambda function."
  type        = string
  default     = null
}

variable "filename" {
  description = "(Optional) The path to the .zip file that contains the Lambda function source code."
  type        = string
  default     = null
}

variable "timeout" {
  description = "(Optional) The amount of time the Lambda function has to run in seconds. For details see https://docs.aws.amazon.com/lambda/latest/dg/gettingstarted-limits.html"
  type        = number
  default     = 3
}

# ----------------------------------------------------------------------------------------------------------------------
# MODULE CONFIGURATION PARAMETERS
# These variables are used to configure the module.
# See https://medium.com/mineiros/the-ultimate-guide-on-how-to-write-terraform-modules-part-1-81f86d31f024
# ----------------------------------------------------------------------------------------------------------------------

variable "module_enabled" {
  type        = bool
  description = "(Optional) Whether to create resources within the module or not."
  default     = true
}

variable "function_tags" {
  description = "(Optional) A map of tags that will be applied to the function."
  type        = map(string)
  default     = {}
}

variable "module_tags" {
  description = "(Optional) A map of tags that will be applied to all created resources that accept tags. Tags defined with 'module_tags' can be overwritten by resource-specific tags."
  type        = map(string)
  default     = {}
}

variable "module_depends_on" {
  type        = any
  description = "(Optional) A list of external resources the module depends_on."
  default     = []
}
