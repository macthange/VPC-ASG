data "aws_ami" "golden_image" {
  owners      = ["060139604389"]
  most_recent = true
  filter {
    name   = "name"
    values = ["refinitiv-amzn2-hvm-*"]
  }
}




data "aws_iam_account_alias" "current" {}
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

