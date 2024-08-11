module "static_hosting_cloudfront" {
  source                = "../../module/cloudfront"
  s3_bucket_domain_name = module.s3_static_hosting.bucket_domain_name
  s3_bucket_id          = module.s3_static_hosting.bucket_id
}
