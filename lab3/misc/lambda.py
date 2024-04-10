import boto3
from urllib import request
import os

ssm_client = boto3.client('ssm')
ec2_client = boto3.client('ec2')

def lambda_handler(event, context):
    response = ssm_client.get_parameter(Name='current-base-ami-id')
    current_base_ami_id = response['Parameter']['Value']

    print(f'Current base AMI ID in parameter store: {current_base_ami_id}')
    
    # Check for the latest CentOS based AMI
    response = request.urlopen("http://hip.daohiep.me/images/aws/centos/latest")
    latest_base_ami_id = response.read().decode('utf-8')
    print(f'Latest base AMI ID in the image repository: {latest_base_ami_id}')

    if current_base_ami_id == latest_base_ami_id:
        print('No new base AMI found.')
        return {
            'statusCode': 200,
            'body': 'No new base AMI found.'
        }

    # Set the new base AMI ID in parameter store
    # response = ssm_client.put_parameter(
    #     Name='current-base-ami-id',
    #     Value=latest_base_ami_id,
    #     Type='String',
    #     Overwrite=True
    # )

    # Trigger the Jenkins pipeline build, with the new base AMI ID as a parameter
    JENKINS_URL = os.environ['JENKINS_URL']
    JENKINS_JOB_AUTH_TOKEN = ssm_client.get_parameter(Name='/jenkins/auth_token')['Parameter']['Value']
    request.urlopen(f'{JENKINS_URL}/buildByToken/buildWithParameters?job=HelloWorld&token={JENKINS_JOB_AUTH_TOKEN}&AMI_ID={latest_base_ami_id}')

    return {
        'statusCode': 200,
        'body': 'New base AMI found. Triggered Jenkins pipeline build.'
    }
