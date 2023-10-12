
## Build a ECR
module "ecr" {
  source        = "./modules/ecr"
  repo_ecr_name = var.app_name_repository
}
## Build a EKS
module "eks" {
  source        = "./modules/eks"
  repo_eks_name = var.app_name_repository
}

## Build CodeBuild projects
module "codebuild" {
  source                      = "./modules/codebuild"
  project_build_app_name      = var.app_name_repository
  project_build_code_app_name = "${var.app_name_repository}-codebuild"
  project_test_unit_app_name  = "${var.app_name_repository}-test"
  project_build_code_review   = "${var.app_name_repository}-code-review"
  project_build_docker_image  = "${var.app_name_repository}-docker-image"
  bucket_name                 = var.bucket_name_demo
  ecr_arn                     = module.ecr.aws_ecr_arn
  depends_on                  = [module.ecr]
  ip_sonar                    = var.ip_sonar
  project_key_sonar           = var.project_key_sonar
  token_sonar                 = var.token_sonar
  account_aws                 = var.account_aws
  aws_region                  = var.aws_region
}

## Build a CodePipeline
module "codepipeline" {
  source                      = "./modules/codepipeline"
  branch_release              = "main"
  codepipeline_name           = "${var.app_name_repository}-pipeline"
  project_code_build_app_name = "${var.app_name_repository}-codebuild"
  project_test_app_name       = "${var.app_name_repository}-test"
  project_build_code_review   = "${var.app_name_repository}-code-review"
  project_build_docker_image  = "${var.app_name_repository}-docker-image"
  bucket_name                 = var.bucket_name_demo
  github_repo_owner           = var.owner_github
  repository_name             = var.app_name_repository
  github_oauth_token          = var.github_oauth_token
}

