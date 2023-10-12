
variable "project_build_app_name" {
  description = "Name for CodeBuild App React"
}

variable "project_build_code_app_name" {
  description = "Name for CodeBuild build app"
}

variable "bucket_name" {
  description = "bucket for deploy app"
}

variable "project_test_unit_app_name" {
  description = "Name for CodeBuild test app"
}

variable "ip_sonar" {
  description = "IP sonarqube"
}

variable "project_key_sonar" {
  description = "project name sonarqube"
}

variable "token_sonar" {
  description = "token sonarqube"
}

variable "account_aws" {}

variable "aws_region" {}

variable "project_build_code_review" {}

variable "project_build_docker_image" {}

variable "ecr_arn" {}
