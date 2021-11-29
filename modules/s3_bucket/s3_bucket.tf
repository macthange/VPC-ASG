
resource "aws_s3_bucket" "s3_bucket_default" {

  count  = var.s3_enabled ? 1 : 0
  bucket = local.s3_bucket_name
  acl    = "private" #private public-read public-read-write authenticated-read aws-exec-read log-delivery-write
  #  acl          = "public-read" 
  force_destroy = var.s3_destroy
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = var.aws_kms_key_arn
        sse_algorithm     = "aws:kms"
        #sse_algorithm = "AES256"
      }
    }
  }


  #  versioning {
  #    enabled = true
  #  }
  #
  #  lifecycle_rule {
  #    abort_incomplete_multipart_upload_days = 0
  #    enabled                                = true
  #    id                                     = "RemoveExpiredObjectDeleteMarkers"
  #    tags                                   = {}
  #
  #    expiration {
  #      days                         = 0
  #      expired_object_delete_marker = true
  #    }
  #  }
  #
  #  lifecycle_rule {
  #    abort_incomplete_multipart_upload_days = 7
  #    enabled                                = true
  #    id                                     = "DeleteIncompleteMultipartUploads"
  #    tags                                   = {}
  #  }

  tags = {
    Name        = local.s3_bucket_name
    Owner       = local.owner
    Environment = var.env
  }


}

resource "aws_s3_bucket_policy" "s3_bucket" {
  bucket     = aws_s3_bucket.s3_bucket_default.*.id[0]
  depends_on = [aws_s3_bucket.s3_bucket_default]
  # Terraform's "jsonencode" function converts a
  # Terraform expression's result to valid JSON syntax.
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [{
      "Sid" : "statement1",
      "Effect" : "Allow",
      "Principal" : {
        "AWS" : "arn:aws:iam::${local.account_id}:user/service-user/*"
      },
      "Action" : "s3:*Object",
      "Resource" : "${aws_s3_bucket.s3_bucket_default.*.arn[0]}/*"
    }]
  })
}


output "s3_bucket_name" {
  value       = aws_s3_bucket.s3_bucket_default.*.bucket[0]
  description = "s3_bucket_default_bucket name for app_name environment"
}
output "s3_bucket_id" {
  value       = aws_s3_bucket.s3_bucket_default.*.id[0]
  description = "s3_bucket_default_bucket name for app_name environment"
}

output "s3_bucket_arn" {
  value       = aws_s3_bucket.s3_bucket_default.*.arn[0]
  description = "s3_bucket_default_bucket name for app_name environment"
}


/*
resource "aws_s3_bucket_public_access_block" "s3_bucket_default_block_public_access" {
  bucket = var.s3_bucket_name

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


output "s3_bucket_name" {
  value       = aws_s3_bucket.s3_bucket_default.*.bucket[0]
  description = "s3_bucket_default_bucket name for app_name environment"
}

output "s3_bucket_website_endpoint" {
  value       = aws_s3_bucket.s3_bucket_default.*.website_endpoint[0]
  description = "s3_bucket static web hosting website_endpoint"
}
*/