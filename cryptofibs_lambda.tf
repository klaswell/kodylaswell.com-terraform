resource "aws_lambda_function" "cryptofibs_lambda" {
  filename      = "cryptofibs_lambda_payload.zip"
  function_name = "cryptofibs"
  role          = aws_iam_role.iam_for_cryptofibs_lambda.arn
  handler       = "index.handler"
  description   = "Deployed by Terraform"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = filebase64sha256("cryptofibs_lambda_payload.zip")

  runtime = "nodejs14.x"
}

resource "aws_lambda_permission" "cryptofibs_v2_api_lambda_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.cryptofibs_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.cryptofibs_v2_api.execution_arn}/*/POST/fib"
}