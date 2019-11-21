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
Create a role on cloudwatch events to run lambda function every hour. You could to use this cron expression
```
cron(1 */1 * * ? *)
```

To this lambda stop and start instances, you need to set some tags on instances.

- *weekday_on*
- *on*
- *off*

# Tags descibe

## weekday_on

This tag is required and define each week days that function will run on instances.

The parttern is 7 zeros or ones separated by dot:
0.0.0.0.0.0.0

Each digit is a weekday, this sequence began on sunday, for example: sunday.monday.tuesday.wednesday.thursday.friday.saturday

If the value is zero (0) the function don't will execute in respective day, but if it's one (1) the function will be executed

For example if you want to execute only business days: 1.1.1.1.1.0.0

## on

Tag "on" mean the hour that instance will turn on. This tag must be with two digits: 00,01,02,03,04,05,06,07....,21,22,23

## off

Tag "off" mean the hour that instance will turn off. This tag must be with two digits: 00,01,02,03,04,05,06,07....,21,22,23
