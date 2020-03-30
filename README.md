Lambda StopStart EC2
=================

This lambda script start and stop ec2 instances according to the intances Tags

# Use

Create a role with below policy and attach to lambda function

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "arn:aws:logs:*:*:*"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeInstances",
                "ec2:Start*",
                "ec2:Stop*"
            ],
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor2",
            "Effect": "Allow",
            "Action": "logs:CreateLogGroup",
            "Resource": "arn:aws:logs:*:*:*"
        }
    ]
}
```
Create a role on cloudwatch events to run lambda function every minute. You could to use this cron expression
```
cron(* * * * ? *)
```

To this lambda stop and start instances, you need to set some tags on instances.

- *schedule_on*
- *schedule_off*

# Tags descibe

## schedule_on

This tag is required and define each week days, hours and minute that function will run on instances.

The parttern is 7 hours (HH:MM) or ones separated by dot:
00:00.00:00.00:00.00:00.00:00.00:00.00:00

Each position is a weekday, this sequence began on sunday, for example: sunday.monday.tuesday.wednesday.thursday.friday.saturday

If the value is nn:nn the function won't execute in respective day, but if it's a valid hour the function will be executed

For example if you want to execute only business days: nn:nn.08:30.08:00.09:10.08:00.08:00.nn:nn

## schedule_off

This tag is required and define each week days and hour that function will stop on instances.

The parttern is 7 hours (HH:MM) or ones separated by dot:
00:00.00:00.00:00.00:00.00:00.00:00.00:00

Each position is a weekday, this sequence began on sunday, for example: sunday.monday.tuesday.wednesday.thursday.friday.saturday

If the value is nn:nn the function won't execute in respective day, but if it's a valid hour the function will be executed

For example if you want to execute only business days: nn:nn.19:00.19:12.19:00.17:00.19:00.nn:nn
