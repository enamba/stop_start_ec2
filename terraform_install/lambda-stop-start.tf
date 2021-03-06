resource "aws_iam_role" "iam_lambda_stop_start_instance" {
  name = "lambda_stop_start_instance_${var.region_name}"

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

data "aws_iam_policy_document" "eventwatch_ec2_stop_start" {
  statement {
    actions = [
      "ec2:DescribeInstances",
      "ec2:Start*",
      "ec2:Stop*",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_cloudwatch_log_group" "lambda_start_stop_intance" {
  name = "/aws/lambda/lambda_start_stop_intance_${var.region_name}"
  tags = "${var.tags}"
}

resource "aws_iam_policy" "eventwatch_ec2_stop_start" {
  name   = "eventwatch_ec2_stop_start_${var.region_name}"
  path   = "/"
  policy = "${data.aws_iam_policy_document.eventwatch_ec2_stop_start.json}"
}


resource "aws_iam_role_policy_attachment" "eventwatch_ec2_policy_attach" {
  role       = "${aws_iam_role.iam_lambda_stop_start_instance.name}"
  policy_arn = "${aws_iam_policy.eventwatch_ec2_stop_start.arn}"
}

resource "aws_cloudwatch_event_rule" "every_minute" {
  name                = "every-minute-ec2_${var.region_name}"
  description         = "Fires every minute"
  schedule_expression = "cron(* * * * ? *)"
  tags                = "${var.tags}"
}

resource "aws_cloudwatch_event_target" "check_every_one_minute_instance" {
  rule      = "${aws_cloudwatch_event_rule.every_minute.name}"
  target_id = "lambda_stop_start_instance_${var.region_name}"
  arn       = "${aws_lambda_function.lambda_stop_start_instance.arn}"
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_lambda_stop_start_instance" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.lambda_stop_start_instance.function_name}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.every_minute.arn}"
}

data "archive_file" "zip_ec2" {
  type        = "zip"
  source_file = "../lambda_function.py"
  output_path = "./src_lambda-start-stop-instance.zip"
}

resource "aws_lambda_function" "lambda_stop_start_instance" {
  filename         = ""
  function_name    = "lambda_start_stop_instance_${var.region_name}"
  filename         = "${data.archive_file.zip_ec2.output_path}"
  source_code_hash = "${data.archive_file.zip_ec2.output_base64sha256}"
  role             = "${aws_iam_role.iam_lambda_stop_start_instance.arn}"
  handler          = "lambda_function.lambda_handler"

  timeout = 10
  runtime = "python3.7"
  tags    = "${var.tags}"

  environment {
    variables = {
      REGION_NAME = "${var.region_name}"
      TZ          = "${var.timezone_name}"
    }
  }
}
