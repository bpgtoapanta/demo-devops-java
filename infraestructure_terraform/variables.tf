# Access key personal account
variable "aws_access_key" {
  default = ""
}
# Secret key personal account
variable "aws_secret_key" {
  default = ""
}

variable "aws_region" {
  description = "Region"
  default     = "us-east-1"
}

variable "app_name_repository" {
  description = "Repository name"
  default     = ""
}

variable "github_oauth_token" {
  description = "Repository token"
  default     = ""
}

variable "bucket_name_demo" {
  description = "Bucket for demo devsu"
  default     = ""
}

variable "owner_github" {
  description = "Owner account github"
  default     = ""
}

variable "ip_sonar" {
  default = ""
}

variable "project_key_sonar" {
  default = ""
}

variable "token_sonar" {
  default = ""
}

variable "account_aws" {
  default = ""
}

