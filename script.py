import boto3
import time
from datetime import tzinfo, timedelta, datetime
import os


def lambda_handler(event, context):
    time.tzset()
    time_now = time.strftime('%H:%M')

    ec2 = boto3.client('ec2', region_name=os.environ['REGION_NAME'])
    turnOff_instancesId = []
    turnOn_instancesId = []
    weekArray = ["?????", "?????", "?????", "?????", "?????", "?????", "?????"]

    weekArray[int(time.strftime('%w'))] = str(time_now) # places the hour and minute in the array for that weekday
    findWeek = '.'.join(weekArray)                      # create a custome filter with the weekdays to filter on Ex: nn.20.20.20.20.20.nn
    
    
    print('Time Now: ' + str(time_now))
    print('findWeek: ' + findWeek)

    # filter to get all instances to turn on.
    custom_filter = [{
            'Name': 'tag:schedule_on',
            'Values': [findWeek]
    }]
    response = ec2.describe_instances(Filters=custom_filter)
    for instances in response['Reservations']:
        for instance in instances['Instances']:
            turnOn_instancesId.append(instance['InstanceId'])

    # filter to get all instances to turn off.
    custom_filter = [{
            'Name': 'tag:schedule_off',
            'Values': [findWeek]
    }]
    
     
    response = ec2.describe_instances(Filters=custom_filter)
    for instances in response['Reservations']:
        for instance in instances['Instances']:
            turnOff_instancesId.append(instance['InstanceId'])

    # turn off instance list
    if (len(turnOff_instancesId) > 0):
        ec2.stop_instances(InstanceIds=turnOff_instancesId)
    print('Stopping your instances: ' + str(turnOff_instancesId))

    # turn on instance list
    if (len(turnOn_instancesId) > 0):
        ec2.start_instances(InstanceIds=turnOn_instancesId)
    print('Starting your instances: ' + str(turnOn_instancesId))
