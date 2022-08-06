resource "aws_codebuild_project" "terraform_codebuild_project" {
  name          = var.project_name
  build_timeout = "120"
  service_role  = aws_iam_role.code_build.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  cache {
    type = "NO_CACHE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:6.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true

    environment_variable {
      name  = "TERRAFORM_WORKSPACE"
      value = terraform.workspace
    }

    environment_variable {
      name  = "TERRAFORM_SHOULD_APPLY"
      value = var.terraform_should_apply
    }
  }

  source {
    type      = "GITHUB"
    location  = "https://github.com/murayama-molo/cd-with-terraform-and-codebuild"
    buildspec = "deployment/buildspec.yaml"
  }

  source_version = "master"

  vpc_config {
    security_group_ids = var.vpc_config.security_group_ids
    subnets            = var.vpc_config.subnet_ids
    vpc_id             = var.vpc_config.vpc_id
  }
}


resource "aws_codebuild_webhook" "terraform_codebuild_webhook" {
  project_name = aws_codebuild_project.terraform_codebuild_project.name
  build_type   = "BUILD"
  filter_group {
    filter {
      type    = "EVENT"
      pattern = "PUSH"
    }

    filter {
      type    = "HEAD_REF"
      pattern = "main"
    }
  }
}

resource "aws_codebuild_source_credential" "terraform_codebuild_credential" {
  auth_type = "PERSONAL_ACCESS_TOKEN"
  server_type = "GITHUB"
  token = var.access_token
}