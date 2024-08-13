data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "lambda-exec-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "archive_file" "lambda_package" {
  type        = "zip"
  source_file = "index.py"
  output_path = "index.zip"
}

resource "aws_lambda_function" "hello_world_lambda" {
  function_name = "hello-world-lambda-function"

  handler = "lambda_function.lambda_handler"
  runtime = "python3.11"

  filename         = data.archive_file.lambda_package.output_path
  source_code_hash = data.archive_file.lambda_package.output_base64sha256

  role = aws_iam_role.iam_for_lambda.arn

  memory_size = 254
  timeout     = 300

}