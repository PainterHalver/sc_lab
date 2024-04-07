- Set app proxy through Shell environment variables
- Alert SNS when app is stopped
- Set `notification_email` var: The email to send SNS notifications to

### Notes

- To use `ip route add` to route through NAT Instance, the NAT Instance must have a network interface (with source-dest-check off) inside the same subnet as the EC2 instance.
- https://access.redhat.com/solutions/7001170
