# Checklist

🟨Use Terraform
🟥Use Makefile
🟩Setup Jenkins for CI/CD
🟨Build AMI using packer
🟥Build a BASE AMI that is used to build all other AMIs
Whenever a new base AMI is released (built), other AMI builds are triggered automatically
🟨Use lambda function to check source AMI and trigger Jenkins pipelines
🟨Create EFS: as persistant data storage, store source code or app data permanently

🟥App (3-tier model)
Flask API
user-data: Auto mount EFS
Run Docker Compose
Use Boto3, pandas(export CSV)... to export non-compliance security groups (Webpage > Click a button > List URLs to download CSV files)
🟥Store CSV lists to DB
App pipelines:

- Build Docker image → ECR
- 🟥 Use SonarQube to scan Docker image
- 🟥 Deploy new app version
- 🟥 Patching with new base AMI

🟨Tagging resources with required tags
Group: CyberDevOps
Environment: development

🟨AWS Config:
Rule to check tag compliance
Rule to check SG rule compliance
🟨SNS: send monitoring alerts (CPU, memory, disk)
🟨DNS (Route53)
🟨ALB
🟨ASG
🟨RDS
🟨S3 (CSV files)
🟨Encrypted with KMS key

### Notes

- Jenkins seedjob flow: JCasC -> Seed Job -> External Job DSLs -> Job groovy scripts
- Terraform ECR Public gets `400` cannot delete if it has images, but can delete whole registry using console
- https://www.reddit.com/r/aws/comments/1ax2zv4/regional_data_transfer_usage_generated_by_ubuntu/
- https://aws.amazon.com/vpc/faqs/#:~:text=two%20instances%20communicate%20using%20public%20IP
- yum mirrors may deny access from some regions like `seoul`, best to use `sydney` or `singapore`
- AWS's AMI has package mananger source set to AWS's own mirror, which will cost REGIONAL DATA TRANSFER as opposed to using public mirrors, which is free inbound: https://www.reddit.com/r/aws/comments/17s1jsd/comment/ksui2rn/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button