variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "sqs_queue_arn" {
  description = "ARN of the SQS queue for notifications"
  type        = string
}

variable "glacier_transition_days" {
  description = "Number of days before transitioning to Glacier"
  type        = number
  default     = 30
}