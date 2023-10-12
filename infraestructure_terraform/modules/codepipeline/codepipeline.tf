resource "aws_s3_bucket" "practica-aws-codepipeline-s3-bucket" {
  bucket        = var.bucket_name
  force_destroy = true
}

resource "aws_codestarconnections_connection" "app_java" {
  name          = "app_java-${var.repository_name}"
  provider_type = "GitHub"
}


resource "aws_codepipeline" "java_aws_codepipeline" {
  name     = var.codepipeline_name
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.practica-aws-codepipeline-s3-bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["SourceArtifact"]
      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.app_java.arn
        FullRepositoryId = "${var.github_repo_owner}/${var.repository_name}"
        BranchName       = var.branch_release
      }
    }
  }

  stage {
    name = "Code_Build"

    action {
      name             = "Code_Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = []
      version          = "1"

      configuration = {
        ProjectName = "${var.project_code_build_app_name}"
      }
    }
  }

  stage {
    name = "Test"

    action {
      name             = "Test"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = []
      version          = "1"

      configuration = {
        ProjectName = "${var.project_test_app_name}"
      }
    }
  }

  stage {
    name = "Code_Review"

    action {
      name             = "Code_Review"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = []
      version          = "1"

      configuration = {
        ProjectName = "${var.project_build_code_review}"
      }
    }
  }

  stage {
    name = "Build_Image"

    action {
      name             = "Build_Image"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = []
      version          = "1"

      configuration = {
        ProjectName = "${var.project_build_docker_image}"
      }
    }
  }
}

