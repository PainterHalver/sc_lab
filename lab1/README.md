- Stress cpu: `stress-ng --cpu 0 --cpu-load 70`
- Stress memory: `stress-ng --vm 2 --vm-bytes 256M --vm-keep`
- Example ldap user: `john:ldap123`

### To Run

- Change S3 bucket name
- Set `ldap_admin_password` var: The password for `cn=Directory Manager`
- Set `notification_email` var: The email to send SNS notifications to
