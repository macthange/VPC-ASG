
resource "aws_kms_key" "kms" {
  description              = "KMS key for ctp-udbor-common"
  customer_master_key_spec = var.key_spec
  is_enabled               = var.enabled
  enable_key_rotation      = var.rotation_enabled
  #policy                   = [data.aws_iam_policy_document.ssm_key.json] 
  deletion_window_in_days = 30
  tags = {
    Name        = local.kms_key
    Owner       = local.owner
    Environment = var.env
  }
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "Enable IAM User Permissions",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : [
            "arn:aws:iam::${local.account_id}:role/human-role/${var.deployer_role}",
            "arn:aws:iam::${local.account_id}:root",

          ]
        },
        "Action" : "kms:*",
        "Resource" : "*"
      },

      {
        "Sid" : "Enable s3 Principal",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "s3.amazonaws.com"
        },
        "Action" : [
          "kms:GenerateDataKey",
          "kms:Decrypt"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "Enable s3 events",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "events.amazonaws.com"
        },
        "Action" : [
          "kms:GenerateDataKey",
          "kms:Decrypt"
        ],
        "Resource" : "*"
      }
    ]
  })
}

# Add an alias to the key
resource "aws_kms_alias" "kms" {
  name          = var.kms_alias_name
  target_key_id = aws_kms_key.kms.key_id
}

