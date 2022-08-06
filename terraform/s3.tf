module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "test-bucket-${terraform.workspace}"

  versioning = {
    enabled = true
  }

  tags = {
    workspace = terraform.workspace
  }
}
