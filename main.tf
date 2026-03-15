module "label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"
  context = module.this.context
}

data "archive_file" "zips" {
  for_each    = toset(["get_authors", "get_courses", "get_course", "save_course", "update_course", "delete_course"])
  type        = "zip"
  source_dir  = "${path.module}/src/${each.key}"
  output_path = "${path.module}/builds/${each.key}.zip"
}

module "lambdas" {
  for_each      = data.archive_file.zips
  source        = "./modules/lambda"
  namespace     = var.namespace
  stage         = var.stage
  name          = var.name
  function_name = "${module.label.id}-${replace(each.key, "_", "-")}"
  role_arn      = module.iam.lambda_role_arn
  filename      = each.value.output_path
  handler       = "index.handler"
  runtime       = "nodejs18.x"
}

module "api_gateway" {
  source      = "./modules/api_gateway"
  namespace   = var.namespace
  stage       = var.stage
  name        = var.name
  lambda_arns = { for k, v in module.lambdas : k => v.function_arn }
}