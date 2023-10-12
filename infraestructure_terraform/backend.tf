# Require TF version to be same as or greater than 0.12.16
terraform {
  required_version = ">=1.2.4"
  backend "local" {}
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.23.0"
    }
  }
}
