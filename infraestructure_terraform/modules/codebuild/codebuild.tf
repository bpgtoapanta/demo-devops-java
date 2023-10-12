data "template_file" "buildspec_build_code_code" {
  template = file("buildspec_code_build_app.yml")
}

data "template_file" "buildspec_test_unit_code" {
  template = file("buildspec_test_unit_app.yml")
}

data "template_file" "buildspec_review_code" {
  template = file("buildspec_build_review_code.yml")
  vars = {
    ip_sonar          = var.ip_sonar
    project_key_sonar = var.project_key_sonar
    token_sonar       = var.token_sonar
  }
}

data "template_file" "buildspec_docker_image" {
  template = file("buildspec_build_docker_image.yml")
  vars = {
    aws_region  = var.aws_region
    account_aws = var.account_aws
  }
}

# Create CodeBuild Project for springboot-java
resource "aws_codebuild_project" "project_build_code_app" {
  name         = var.project_build_code_app_name
  description  = "app build_code codebuild project"
  service_role = aws_iam_role.codebuild_role.arn

  artifacts {
    encryption_disabled    = false
    packaging              = "NONE"
    override_artifact_name = false
    type                   = "CODEPIPELINE"
    name                   = var.project_build_code_app_name
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = data.template_file.buildspec_build_code_code.rendered
  }
}


resource "aws_codebuild_project" "project_test_app" {
  name         = var.project_test_unit_app_name
  description  = "app test project"
  service_role = aws_iam_role.codebuild_role.arn

  artifacts {
    encryption_disabled    = false
    packaging              = "NONE"
    override_artifact_name = false
    type                   = "CODEPIPELINE"
    name                   = var.project_test_unit_app_name
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = data.template_file.buildspec_test_unit_code.rendered
  }
}

resource "aws_codebuild_project" "project_build_code_review" {
  name         = var.project_build_code_review
  description  = "review code codebuild project"
  service_role = aws_iam_role.codebuild_role.arn

  artifacts {
    encryption_disabled    = false
    packaging              = "NONE"
    override_artifact_name = false
    type                   = "CODEPIPELINE"
    name                   = var.project_build_code_review
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "IP_SONAR"
      value = var.ip_sonar
    }

    environment_variable {
      name  = "PROJECT_KEY_SONAR"
      value = var.project_key_sonar
    }

    environment_variable {
      name  = "TOKEN_SONAR"
      value = var.token_sonar
    }
  }



  source {
    type      = "CODEPIPELINE"
    buildspec = data.template_file.buildspec_review_code.rendered
  }

}


resource "aws_codebuild_project" "project_build_docker_image" {
  name         = var.project_build_docker_image
  description  = "review code codebuild project"
  service_role = aws_iam_role.codebuild_role.arn

  artifacts {
    encryption_disabled    = false
    packaging              = "NONE"
    override_artifact_name = false
    type                   = "CODEPIPELINE"
    name                   = var.project_build_docker_image
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true

    environment_variable {
      name  = "REGION_AWS"
      value = var.aws_region
    }

    environment_variable {
      name  = "ACCOUNT_AWS"
      value = var.account_aws
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = data.template_file.buildspec_docker_image.rendered
  }

}
