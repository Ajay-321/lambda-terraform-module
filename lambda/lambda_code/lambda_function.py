import boto3
import os

ec2 = boto3.client('ec2')

def lambda_handler(event, context):
    # Get tag key and value from environment variables (or hardcode if needed)
    tag_key = os.environ.get('TAG_KEY', 'Environment')
    tag_value = os.environ.get('TAG_VALUE', 'Dev')

    # Find instances with the given tag
    filters = [
        {
            'Name': f'tag:{tag_key}',
            'Values': [tag_value]
        },
        {
            'Name': 'instance-state-name',
            'Values': ['running']  # Only stop running instances
        }
    ]

    response = ec2.describe_instances(Filters=filters)

    # Collect instance IDs
    instance_ids = []
    for reservation in response['Reservations']:
        for instance in reservation['Instances']:
            instance_ids.append(instance['InstanceId'])

    if instance_ids:
        print(f"Stopping instances: {instance_ids}")
        ec2.stop_instances(InstanceIds=instance_ids)
    else:
        print("No running instances found with the specified tag.")

    return {
        'statusCode': 200,
        'body': f"Processed instances: {instance_ids}"
    }
