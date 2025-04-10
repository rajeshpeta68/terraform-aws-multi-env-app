#provider "aws" {
#  region = var.aws_region[terraform.workspace]
#  
#}

resource "aws_s3_bucket" "terraform_multi_env_setup" {
    bucket = "bny-multi-env-setup"
    #acl    = "private"
    force_destroy = true
    tags = {
        Name        = "bny-multi-env-setup"
        Environment = terraform.workspace
    }
    lifecycle {
        prevent_destroy = false
    }
  
}

resource "aws_dynamodb_table" "terraform_lock_table" {
    name         = "terraform-lock-table"
    billing_mode = "PAY_PER_REQUEST"
    hash_key     = "LockID"
  
    attribute {
        name = "LockID"
        type = "S"
    }
  
    tags = {
        Name        = "bny-lock-table"
        Environment = terraform.workspace
    }
  
}
/*
resource "aws_s3_bucket_public_access_block" "tf_state" {
    bucket = aws_s3_bucket.terraform_multi_env_setup.id
  
    block_public_acls       = false
    ignore_public_acls      = false
    block_public_policy     = false
    restrict_public_buckets = false
  
}

resource "aws_s3_bucket_policy" "s3_public_policy" {
    bucket = aws_s3_bucket.terraform_multi_env_setup.id
  
    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Principal = "*"
                Action   = "s3:GetObject"
                Resource = "${aws_s3_bucket.terraform_multi_env_setup.arn}/*"
            }
        ]
    })
  
}
*/