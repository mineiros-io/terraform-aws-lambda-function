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

variable "aliases" {
  description = "(Optional) A map of aliases (keyed by the alias name) that will be created for the Lambda function. If 'version' is omitted, the alias will automatically point to '$LATEST'."
  type        = any
  default     = {}
}

variable "dead_letter_config_target_arn" {
  description = "(Optional) The ARN of an SNS topic or SQS queue to notify when an invocation fails. If this option is used, the function's IAM role must be granted suitable access to write to the target object, which means allowing either the sns:Publish or sqs:SendMessage action on this ARN, depending on which service is targeted."
  type        = string
  default     = ""
}

variable "description" {
  description = "(Optional) A description of what the Lambda function does."
  type        = string
  default     = null
}

variable "environment_variables" {
  description = "(Optional) A map of environment variables to pass to the Lambda function. AWS will automatically encrypt these with KMS if a key is provided and decrypt them when running the function."
  type        = map(string)
  default     = {}
}

variable "filename" {
  description = "(Optional) The path to the .zip file that contains the Lambda function source code."
  type        = string
  default     = null
}

variable "kms_key_arn" {
  description = "(Optional) The ARN for the KMS encryption key that is used to encrypt environment variables. If none is provided when environment variables are in use, AWS Lambda uses a default service key."
  type        = string
  default     = null
}

variable "layer_arns" {
  description = "(Optional) Set of Lambda Layer Version ARNs (maximum of 5) to attach to your Lambda Function. For details see https://docs.aws.amazon.com/lambda/latest/dg/configuration-layers.html"
  type        = set(string)
  default     = []
}

variable "memory_size" {
  description = "(Optional) Amount of memory in MB the Lambda function can use at runtime. For details see https://docs.aws.amazon.com/lambda/latest/dg/gettingstarted-limits.html"
  type        = number
  default     = 128
}

variable "publish" {
  description = "(Optional) Whether to publish creation/change as new Lambda function. This allows you to use aliases to refer to execute different versions of the function in different environments."
  type        = bool
  default     = false
}

variable "reserved_concurrent_executions" {
  description = "(Optional) The amount of reserved concurrent executions for this lambda function. A value of 0 disables lambda from being triggered and -1 removes any concurrency limitations. For details see https://docs.aws.amazon.com/lambda/latest/dg/invocation-scaling.html"
  type        = string
  default     = "-1"
}

variable "role_arn" {
  description = "(Optional) The ARN of the policy that is used to set the permissions boundary for the IAM role for the Lambda function."
  type        = string
  default     = null
}

variable "s3_bucket" {
  description = "(Optional) The S3 bucket location containing the function's deployment package. Conflicts with 'filename'. This bucket must reside in the same AWS region where you are creating the Lambda function."
  type        = string
  default     = null
}

variable "s3_key" {
  description = "(Optional) The S3 key of an object containing the function's deployment package. Conflicts with 'filename'."
  type        = string
  default     = null
}

variable "source_code_hash" {
  description = "(Optional) Used to trigger updates. Must be set to a base64-encoded SHA256 hash of the package file specified with either filename or s3_key."
  type        = string
  default     = null
}

variable "s3_object_version" {
  description = "(Optional) The object version containing the function's deployment package. Conflicts with 'filename'."
  type        = string
  default     = null
}

variable "timeout" {
  description = "(Optional) The amount of time the Lambda function has to run in seconds. For details see https://docs.aws.amazon.com/lambda/latest/dg/gettingstarted-limits.html"
  type        = number
  default     = 3
}

variable "tracing_mode" {
  description = "(Optional) Can be either 'PassThrough' or 'Active'. If set to 'PassThrough', Lambda will only trace the request from an upstream service if it contains a tracing header with 'sampled=1'. If set to 'Active', Lambda will respect any tracing header it receives from an upstream service. If no tracing header is received, Lambda will call X-Ray for a tracing decision."
  type        = string
  default     = null
}

variable "vpc_subnet_ids" {
  description = "(Optional) A set of subnet IDs associated with the Lambda function."
  type        = set(string)
  default     = []
}

variable "vpc_security_group_ids" {
  description = "(Optional) A set of security group IDs associated with the Lambda function."
  type        = set(string)
  default     = []
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
