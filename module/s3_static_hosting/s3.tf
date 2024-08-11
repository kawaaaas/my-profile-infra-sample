resource "aws_s3_bucket" "static-hosting-bucket" {
  bucket = "${var.shared_prefix}-s3-static-hosting-bucket"

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_website_configuration" "static-hosting-confifg" {
  bucket = aws_s3_bucket.static-hosting-bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}


