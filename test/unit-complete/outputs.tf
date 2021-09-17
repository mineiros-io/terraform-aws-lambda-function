# outputs generate non-idempotent terraform plans so we disable them for now unless we need them.
# output "all" {
#   description = "A map that contains all outputs of the Lambda Function Module."
#   value       = module.lambda
# }

# output "s3_bucket" {
#   description = "All outputs of the 'terraform-aws-s3-bucket' module."
#   value       = module.s3_bucket
# }

# output "s3_object" {
#   description = "All outputs of the 'aws_s3_bucket_object' resource."
#   value       = aws_s3_bucket_object.function
# }
