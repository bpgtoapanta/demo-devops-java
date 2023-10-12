variable "codepipeline_name" {
  description = "Terraform CodeCommit repo name"
}

variable "project_code_build_app_name" {
  description = "Name for CodeBuild app"
}

variable "repository_name" {
  description = "Repository name"
}

variable "github_oauth_token" {
  description = "Token gitlab access"
}

variable "branch_release" {
  description = "branch"
}

variable "bucket_name" {
  description = "bucket for deploy app"
}

variable "github_repo_owner" {
  description = "owner"
}

variable "project_test_app_name" {}

variable "project_build_code_review" {}

variable "project_build_docker_image" {}






