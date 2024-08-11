output "origin_access_identity_arn" {
  value = aws_cloudfront_origin_access_identity.static-hosting-oai.iam_arn
}
