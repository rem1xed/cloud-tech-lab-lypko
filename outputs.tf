output "courses_table_name" {
  value = module.courses_table.table_name
}

output "authors_table_name" {
  value = module.authors_table.table_name
}
output "api_endpoint" {
  value = module.api_gateway.api_endpoint
}