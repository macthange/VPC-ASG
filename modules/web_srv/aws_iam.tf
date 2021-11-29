
resource "aws_iam_role" "asg" {
  name = local.asg_iam_role_name  
  tags = {
    Name        = local.asg_iam_role_name
    Owner       = local.owner
    Environment = var.env
  }

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": [
          "lambda.amazonaws.com",
		  "ec2.amazonaws.com",
		  "s3.amazonaws.com",
		  "sns.amazonaws.com",          
		  "events.amazonaws.com"
        ]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
resource "aws_iam_role_policy" "lambda" {
  name = "${local.asg_iam_role_name}-log"
  role = aws_iam_role.asg.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:logs:*:*:*"
    },
	{
        "Effect": "Allow",
        "Action": [
          "s3:*"
        ],
        "Resource": "*"
    },
    {
      "Action":[
	    "route53:GetHostedZone",
        "autoscaling:DescribeTags",
        "autoscaling:DescribeAutoScalingGroups",
        "autoscaling:CompleteLifecycleAction",
        "ec2:DescribeInstances",
		"ec2:CreateNetworkInterface",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DeleteNetworkInterface",
		"ec2:DescribeSecurityGroups",
        "ec2:DescribeSubnets",
        "ec2:DescribeVpcs",        
        "ec2:CreateTags"
      ],
      "Effect":"Allow",
      "Resource":"*"
    },
    {
      "Action":[
        "route53:ChangeResourceRecordSets",
        "route53:ListResourceRecordSets"
      ],
      "Effect":"Allow",
      "Resource":"arn:aws:route53:::hostedzone/*"
    },    
    {
        "Effect": "Allow",
        "Action": [
          "dynamodb:*"
        ],
        "Resource": "*"
    },
	{
        "Effect": "Allow",
        "Action": [
          "sqs:*"
        ],
        "Resource": "*"
    }
  ]
}
EOF

}

data "aws_iam_policy_document" "kms_use" {
  statement {
    sid = "AllowKMSUse"
    effect = "Allow"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey",
    ]
    resources = [var.kms_master_key_arn]
  }
}
resource "aws_iam_policy" "kms_use" {
  name        = "${local.asg_iam_role_name}-kms"
  description = "Policy to allow use of KMS Key"
  policy      = data.aws_iam_policy_document.kms_use.json
}

resource "aws_iam_role_policy_attachment" "kms_use" {
  role       = aws_iam_role.asg.name
  policy_arn = aws_iam_policy.kms_use.arn
}