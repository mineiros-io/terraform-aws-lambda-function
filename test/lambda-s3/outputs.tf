output "all" {
  description = "A map that contains all outputs of the Lambda Function Module."
  value       = module.lambda
}

output "s3_bucket" {
  description = "All outputs of the 'aws_s3_bucket' resource."
  value       = aws_s3_bucket.lambda
}

output "s3_object" {
  description = "All outputs of the 'aws_s3_bucket_object' resource."
  value       = aws_s3_bucket_object.function
}
