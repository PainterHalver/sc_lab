import boto3
from urllib import request
import os

ssm_client = boto3.client('ssm')
ec2_client = boto3.client('ec2')

def lambda_handler(event, context):
    response = ssm_client.get_parameter(Name='current-hip-ami-id')
    current_hip_ami_id = response['Parameter']['Value']

    print(f'Current base AMI ID in parameter store: {current_hip_ami_id}')

    # Check for the latest CentOS based AMI
    response = request.urlopen("http://hip.daohiep.me/images/aws/centos/latest")
    latest_hip_ami_id = response.read().decode('utf-8')
    print(f'Latest base AMI ID in the image repository: {latest_hip_ami_id}')

    if current_hip_ami_id == latest_hip_ami_id:
        print('No new base AMI found.')
        return {
            'statusCode': 200,
            'body': 'No new base AMI found.'
        }

    # Trigger the Jenkins pipeline build, with the new base AMI ID as a parameter
    JENKINS_URL = os.environ.get('JENKINS_URL')
    JENKINS_JOB_AUTH_TOKEN = ssm_client.get_parameter(Name='/jenkins/auth_token')['Parameter']['Value']
    request.urlopen(f'{JENKINS_URL}/buildByToken/buildWithParameters?job=BuildBaseAMI&token={JENKINS_JOB_AUTH_TOKEN}&HIP_AMI_ID={latest_hip_ami_id}')

    # Set the new base AMI ID in parameter store
    response = ssm_client.put_parameter(
        Name='current-hip-ami-id',
        Value=latest_hip_ami_id,
        Type='String',
        Overwrite=True
    )

    return {
        'statusCode': 200,
        'body': 'New base HIP AMI found. Triggered Jenkins pipeline build.'
    }
