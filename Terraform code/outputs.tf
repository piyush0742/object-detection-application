output "s3_bucket_name" {
  value = module.s3_bucket.bucket_name
}

output "sqs_queue_url" {
  value = module.sqs.queue_url
}

output "lambda_function_name" {
  value = module.lambda.function_name
}

output "sns_topic_arn" {
  value = module.sns.topic_arn
}