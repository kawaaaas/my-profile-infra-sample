module "dynamodb" {
  source        = "../../module/dynamodb"
  shared_prefix = var.shared_prefix
}
