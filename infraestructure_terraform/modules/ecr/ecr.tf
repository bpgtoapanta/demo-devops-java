# Add a project owned by the user
resource "aws_ecr_repository" "create_ecr" {
  name                 = var.repo_ecr_name
  image_tag_mutability = "MUTABLE"
  force_delete = true

  image_scanning_configuration {
    scan_on_push = false
  }

  encryption_configuration{
    encryption_type = "AES256"
  }

}