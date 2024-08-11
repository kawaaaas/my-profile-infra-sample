data "http" "github-actions-openid-configuration" {
  url = "https://token.actions.githubusercontent.com/.well-known/openid-configuration"
}

data "tls_certificate" "github-actions" {
  url = jsondecode(data.http.github-actions-openid-configuration.response_body).jwks_uri
}

resource "aws_iam_openid_connect_provider" "github-actions" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = ["sts.amazonaws.com"]

  thumbprint_list = data.tls_certificate.github-actions.certificates[*].sha1_fingerprint
}

data "aws_iam_policy_document" "github-actions" {
  statement {
    actions = [
      "sts:AssumeRoleWithWebIdentity",
    ]

    principals {
      type = "Federated"
      identifiers = [
        aws_iam_openid_connect_provider.github-actions.arn
      ]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:kawaaaas/my-profile-infra/*"]
    }

  }
}

data "aws_iam_policy_document" "github-actions-ci-session" {
  statement {
    sid    = "AllowS3BucketCreation"
    effect = "Allow"

    actions = [
      "s3:CreateBucket",
      "s3:PutBucketPolicy",
      "s3:PutBucketPublicAccessBlock",
      "s3:PutBucketTagging",
      "s3:PutBucketWebsite",
      "s3:GetBucketLocation"
    ]

    resources = [
      "arn:aws:s3:::*"
    ]
  }

  statement {
    sid    = "AllowCloudFrontDistributionCreation"
    effect = "Allow"

    actions = [
      "cloudfront:CreateDistribution",
      "cloudfront:GetDistribution",
      "cloudfront:GetDistributionConfig",
      "cloudfront:UpdateDistribution",
      "cloudfront:TagResource"
    ]

    resources = [
      "*"
    ]
  }
}

resource "aws_iam_role" "github-actions" {
  name               = "github_actions"
  assume_role_policy = data.aws_iam_policy_document.github-actions.json
}


resource "aws_iam_policy" "github-actions" {
  name   = "github_actions"
  policy = data.aws_iam_policy_document.github-actions-ci-session.json
}

resource "aws_iam_policy_attachment" "github-actions" {
  name       = "github_actions"
  policy_arn = aws_iam_policy.github-actions.arn
  roles      = [aws_iam_role.github-actions.name]
}
