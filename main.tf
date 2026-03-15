
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
  role_arn      = module.iam.role_arns[each.key]
  
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


module "table_courses" {
  source    = "./modules/dynamodb"
  namespace = var.namespace
  stage     = var.stage
  name      = "courses"
}


module "table_authors" {
  source    = "./modules/dynamodb"
  namespace = var.namespace
  stage     = var.stage
  name      = "authors"
}

module "iam" {
  source            = "./modules/iam"
  namespace         = var.namespace
  stage             = var.stage
  authors_table_arn = module.table_authors.table_arn
  courses_table_arn = module.table_courses.table_arn
}