variable "queue_name" {
  description = "Name of the main SQS queue"
  type        = string
}

variable "dlq_name" {
  description = "Name of the Dead Letter Queue"
  type        = string
}

variable "max_receive_count" {
  description = "Maximum number of retries before sending to DLQ"
  type        = number
  default     = 3
}

variable "bucket_name" {
  description = "Name of the S3 bucket for the queue policy"
  type        = string
}