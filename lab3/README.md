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

- Terraform ECR Public gets `400` cannot delete if it has images, but can delete whole registry using console