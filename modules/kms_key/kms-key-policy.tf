data "aws_iam_policy_document" "ssm_key" {
  statement {
    sid       = "Enable IAM User Permissions"
    effect    = "Allow"
    actions   = ["kms:*"]
    resources = ["*"]

    principals {
      type = "AWS"
      identifiers = ["arn:aws:iam::${local.account_id}:root",
        "arn:aws:iam::${local.account_id}:role/human-role/${var.deployer_role}"
      ]
    }
  }

  statement {
    effect = "Allow"
    actions = [
      "kms:GenerateDataKey",
      "kms:Decrypt"
    ]
    principals {
      type        = "AWS"
      identifiers = ["s3.amazonaws.com"]
    }
    resources = ["*"]
  }

}

