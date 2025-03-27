backend "s3" {
    # Recommended for team/production environments
    bucket         = "your-terraform-state-bucket-name"  # Pre-created S3 bucket
    key            = "image-analysis-project/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock"  # For state locking (optional but recommended)
  }