data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "./Lambda/sample.js"
  output_path = "lambda_function.zip"
}

resource "aws_lambda_function" "lambda" {
  filename         = "lambda_function.zip"
  function_name    = "${var.environment}-${var.project}"
  role             = aws_iam_role.lambda_role.arn
  handler          = "sample.handler"
  source_code_hash = "${data.archive_file.lambda_zip.output_base64sha256}"
  runtime          = var.runtime
}

resource "aws_iam_role" "lambda_role" {
  name               = "${var.environment}_${var.project}"
  assume_role_policy = "${file("./Lambda/policy.json")}"
}

resource "aws_lambda_permission" "with_lb" {
  statement_id  = "AllowExecutionFromlb"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.arn
  principal     = "elasticloadbalancing.amazonaws.com"
  source_arn    = var.aws_lb_target_group_arn
}

resource "aws_lb_target_group_attachment" "test" {
  target_group_arn = var.aws_lb_target_group_arn
  target_id        = aws_lambda_function.lambda.arn
  depends_on       = [aws_lambda_permission.with_lb]
}