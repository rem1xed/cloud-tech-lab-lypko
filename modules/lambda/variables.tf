variable "function_name" {
  type = string
}

variable "role_arn" {
  type = string
}

variable "filename" {
  type = string
}

variable "handler" {
  type    = string
  default = "index.handler"
}

variable "runtime" {
  type    = string
  default = "nodejs18.x"
}

variable "source_code_hash" { 
  type = string 
}

variable "courses_table_name" {
  type = string
}

variable "authors_table_name" {
  type = string
}
