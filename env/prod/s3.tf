module "s3_static_hosting" {
  source        = "../../module/s3_static_hosting"
  shared_prefix = var.shared_prefix
}
