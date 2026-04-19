output "courses_table_name" {
  value = module.table_courses.table_name
}

output "authors_table_name" {
  value = module.table_authors.table_name
}

output "api_endpoint" {
  value = module.api_gateway.api_endpoint
}

output "frontend_url" {
  value = module.frontend.website_endpoint
}