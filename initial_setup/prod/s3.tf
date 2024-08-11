module "s3_bucket" {
  source        = "../../module/s3_bucket"
  shared_prefix = var.shared_prefix
}
