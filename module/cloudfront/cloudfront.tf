resource "aws_cloudfront_distribution" "name" {
  origin {
    domain_name = var.s3_bucket_domain_name
    origin_id   = var.s3_bucket_id
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.static-hosting-oai.cloudfront_access_identity_path
    }
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.s3_bucket_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  enabled = true

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["JP"]
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

resource "aws_cloudfront_origin_access_identity" "static-hosting-oai" {}

resource "aws_s3_bucket_policy" "static-hosting-bucket" {
  bucket = var.s3_bucket_id
  policy = data.aws_iam_policy_document.static_hosting_bucket.json
}

data "aws_iam_policy_document" "static-hosting-bucket" {
  statement {
    sid    = "Allow CloudFront"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["${aws_cloudfront_origin_access_identity.static-hosting-oai.iam_arn}"]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.static-hosting-bucket.arn}/*"
    ]
  }
}
