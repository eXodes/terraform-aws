# Requirements

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

## Manual Provisioning

---

Multiple environment state can be manage through Terraform workspace.

1. Create a new workspace for your project environment.
    ```bash
    terraform workspace new <project environment>
    ```

2. Initialize the Terraform environment.
    ```bash
    terraform init
    ```

3. Create new variables file for your new environment with the command below and update the value.
    ```bash
    cp terraform.tfvars.example terraform.tfvars
    ```

4. Apply the Terraform configuration to provision the infrastructure.
    ```bash
    terraform apply -var="name=<project name>" -var="environment=<project environment>"
    ```
   > Note: You can use `-auto-approve` to skip the interactive confirmation.

3. Tear down the infrastructure with Terraform destroy command.
    ```bash
    terraform destroy -var="name=<project name>" -var="environment=<project environment>"
    ```

## Automated Provisioning

---

Automated provisioning can be done through Github Actions workflow.

