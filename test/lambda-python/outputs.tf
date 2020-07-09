output "all" {
  description = "A map that contains all outputs of the Lambda Function Module."
  value       = module.lambda
}

output "sns_topic" {
  description = "The full 'aws_sns_topic' resource."
  value       = aws_sns_topic.lambda
}

output "sns_topic_subscription" {
  description = "The 'aws_sns_topic_subscription' resource."
  value       = aws_sns_topic_subscription.lambda
}
