resource "aws_s3_bucket" "image_bucket" {
  bucket = var.bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.image_bucket.id

  queue {
    queue_arn = var.sqs_queue_arn
    events    = ["s3:ObjectCreated:Put"]
    filter_prefix = "images/"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "glacier_transition" {
  bucket = aws_s3_bucket.image_bucket.id

  rule {
    id     = "glacier-transition-rule"
    status = "Enabled"
    
    filter {
      prefix = "analyzed/"
    }

    transition {
      days          = var.glacier_transition_days
      storage_class = "GLACIER"
    }
  }
}