resource "aws_s3_bucket" "s3-bucket" {
  bucket = "${var.shared_prefix}-s3-bucket"

  versioning {
    enabled = true
  }
}
