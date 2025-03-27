variable "function_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "runtime" {
  description = "Lambda runtime"
  type        = string
  default     = "python3.9"
}

variable "handler" {
  description = "Lambda handler"
  type        = string
  default     = "lambda_function.lambda_handler"
}

variable "timeout" {
  description = "Lambda timeout in seconds"
  type        = number
  default     = 30
}

variable "memory_size" {
  description = "Lambda memory allocation in MB"
  type        = number
  default     = 512
}

variable "source_bucket_name" {
  description = "Name of the source S3 bucket"
  type        = string
}

variable "queue_arn" {
  description = "ARN of the SQS queue"
  type        = string
}

variable "sns_topic_arn" {
  description = "ARN of the SNS topic"
  type        = string
}

variable "target_label" {
  description = "Target label for image detection"
  type        = string
  default     = "Dog"
}

variable "min_confidence" {
  description = "Minimum confidence threshold"
  type        = number
  default     = 90
}