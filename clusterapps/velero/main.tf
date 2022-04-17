terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

resource "aws_s3_bucket" "velero_bucket" {
  bucket = "cadu-homelab-velero"

  tags = {
    service = "velero"
  }
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.velero_bucket.id

  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.velero_bucket.id
  acl    = "private"
}

resource "aws_iam_user" "velero_user" {
  name = "svc_velero_backup"
  path = "/iac/"

  tags = {
    service = "velero"
  }
}

resource "aws_iam_access_key" "velero_user" {
  user = aws_iam_user.velero_user.name
}

resource "aws_iam_user_policy" "velero_user_policy" {
  name = "S3VeleroBackup"
  user = aws_iam_user.velero_user.name

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:DeleteObject",
                "s3:PutObject",
                "s3:AbortMultipartUpload",
                "s3:ListMultipartUploadParts"
            ],
            "Resource": [
                "arn:aws:s3:::${aws_s3_bucket.velero_bucket.id}/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::${aws_s3_bucket.velero_bucket.id}"
            ]
        }
    ]
}
EOF
}