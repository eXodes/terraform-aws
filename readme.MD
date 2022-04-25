Requirements
---

Write IaC script for provision of a 3-tier application in AWS. You can choose Terraform or CloudFormation to provide
the infrastructure. Terraform is most preferred tool. Your code should provision the following:

- VPC with a public and private subnet.
- Route tables for each subnet, private subnet shall have a NAT gateway.
- Application tier and data tier shall be launched in private subnet.
- Web-tier shall be launched in public subnet.
- Web-tier and application-tier both must have autoscaling enabled and shall be behind an ALB
- Proper security groups attached across all the tiers for proper communication.

Bonus points will be given to the assignment with following items:

- Proper DNS mappings with a privately hosted zone in Route53 for application and data-tier.
- IAM roles attached to the application tier to access RDS, CloudWatch and s3 bucket.

Delivery Outcome:

- Once the IaC script is executed, it should create a VPC with valid CIDR block, which contains all VPC related
  Resources such as valid subnets, route tables (public, private), security groups, NAT gateway, Internet Gateway etc.
- It should also create EC2 servers for application-tier and web-tier with autoscaling groups and ALB, and RDS instances
  for data-tier.
- Proper security groups and IAM roles should be in place.
 
