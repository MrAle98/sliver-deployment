resource "aws_iam_policy" "bucket_policy" {
  name        = "my-bucket-policy"
  path        = "/"
  description = "Allow "

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : [
          "s3:GetObject",
          "s3:ListBucket"
        ],
        "Resource" : [
          "arn:aws:s3:::*/*",
          var.sliver-bucket
        ]
      }
    ]
  })
}

resource "aws_iam_role" "bucketReader-role" {
  name = "bucket_reader"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "bucket_reader" {
  role       = aws_iam_role.bucketReader-role.name
  policy_arn = aws_iam_policy.bucket_policy.arn
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-profile"
  role = aws_iam_role.bucketReader-role.name
}