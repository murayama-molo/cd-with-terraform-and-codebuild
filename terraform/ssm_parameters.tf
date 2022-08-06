data "aws_ssm_parameter" "access_token" {
  name = "/secrets/codebuild/access_token"
}