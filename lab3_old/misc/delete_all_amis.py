import boto3

ec2 = boto3.client('ec2', region_name="ap-southeast-1")

all_amis = ec2.describe_images(Owners=['self'])['Images']

for ami in all_amis:
    print(f'Deregistering {ami["ImageId"]}')
    ec2.deregister_image(ImageId=ami['ImageId'])
    for snapshot in ami['BlockDeviceMappings']:
        print(f'Deleting snapshot {snapshot["Ebs"]["SnapshotId"]}')
        ec2.delete_snapshot(SnapshotId=snapshot['Ebs']['SnapshotId'])
