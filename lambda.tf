resource "aws_lambda_function" "resume-Iac" {
  filename = data.archive_file.zip.output_path
  source_code_hash = data.archive_file.zip.output_base64sha256
  function_name = "resume-Iac"
  role = aws_iam_role.iam_for_lambda.arn
  handler = "func.lambda_handler"
  runtime = "python3.9"
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "aws_iam_policy_for_resume_challenge" {
     name = "aws_iam_policy_for_resume_challenge"
    #  path = "/"
     description = "AWS IAM Policy for managing the resume project role"
     policy = jsonencode(
      {
        "Version" : "2012-10-17",
        "Statement" : [
          {
          "Effect" : "Allow",
          "Action" : [
            "dynamodb:*",
            
          ],
           "Resource": "arn:aws:dynamodb:*:*:table/views"
          }

        ]
      }
     )
}

 resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
   role = "${aws_iam_role.iam_for_lambda.name}"
   policy_arn = aws_iam_policy.aws_iam_policy_for_resume_challenge.arn
 }

data "archive_file" "zip" {
    type = "zip"
    source_dir = "${path.module}/lambda"
    output_path = "${path.module}/packedlamda.zip"
  
}

resource "aws_lambda_function_url" "url1" {
  function_name = aws_lambda_function.resume-Iac.function_name
  authorization_type = "NONE"

  cors {
    allow_credentials = true
    allow_origins = ["*"]
    allow_methods = ["*"]
    allow_headers = ["date", "keep-alive"]
    expose_headers = ["keep-alive", "date"]
    max_age = 86400
  }
}

