
module "s3_bucket" {
  source = "./modules/s3"
  
  bucket_name       = var.bucket_name
  lambda_role_arn   = module.lambda.lambda_role_arn
  dlq_arn           = module.sqs.dlq_arn
  sns_topic_arn     = module.sns.sns_topic_arn
  glacier_transition_days = var.glacier_transition_days
}

module "sqs" {
  source = "./modules/sqs"
  
  queue_name          = var.queue_name
  dlq_name            = var.dlq_name
  max_receive_count   = var.max_receive_count
  lambda_role_arn     = module.lambda.lambda_role_arn
}

module "lambda" {
  source = "./modules/lambda"
  
  function_name      = var.lambda_function_name
  runtime            = var.lambda_runtime
  handler            = var.lambda_handler
  timeout            = var.lambda_timeout
  memory_size        = var.lambda_memory_size
  source_bucket_name = var.bucket_name
  queue_arn          = module.sqs.queue_arn
  sns_topic_arn      = module.sns.sns_topic_arn
  target_label       = var.target_label
  min_confidence     = var.min_confidence
}

module "rekognition" {
  source = "./modules/rekognition"
  
  lambda_role_arn = module.lambda.lambda_role_arn
}

module "sns" {
  source = "./modules/sns"
  
  topic_name         = var.sns_topic_name
  subscription_email = var.notification_email
}