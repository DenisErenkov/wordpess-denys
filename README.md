
---

# WordPress Infrastructure with Terraform

This setup provisions a WordPress instance on AWS using Terraform. The infrastructure includes:

- **EC2 instance** for WordPress.
- **RDS** for the MySQL database.
- **ElastiCache Redis** for caching.
- **Security Groups** for controlling access.

## Prerequisites

1. **AWS Account**: Ensure you have AWS credentials configured locally or use an IAM role with appropriate permissions.
2. **Terraform**
3. **SSH Key**: Create or provide an SSH keypair (e.g., `denys.yerenkov`) for EC2 access.

## Infrastructure Overview

- **Amazon EC2**: Hosts WordPress.
- **Amazon RDS**: MySQL database for WordPress.
- **ElastiCache Redis**: For caching.
- **Security Groups**: Configured for both EC2 and RDS, allowing necessary traffic.

## Terraform Variables

Set the following variables in `terraform.tfvars` or pass them directly in the command line:

```hcl
name            = "your-project-name"
db_password     = "your_database_password"
```

### Key Variables

- **name**: Prefix for naming resources.
- **db_password**: Password for the RDS instance.

## Usage

1. **Initialize Terraform**:
   ```bash
   terraform init
   ```

2. **Plan the Deployment**:
   Review the resources that Terraform will create.
   ```bash
   terraform plan
   ```

3. **Apply the Configuration**:
   Deploy the infrastructure.
   ```bash
   terraform apply
   ```

4. **Access WordPress**:
   After applying, retrieve the public IP of the EC2 instance:
   ```bash
   terraform output ec2_public_ip
   ```
   Open a browser and navigate to `http://<EC2_PUBLIC_IP>`.

## Resources Created

### EC2 Instance
- **AMI**: `ami-034cf936557df396e`
- **Instance Type**: `t2.micro`
- **Security Group**: Allows HTTP and SSH access.

### RDS MySQL Database
- **Instance Type**: `db.t3.micro`
- **Engine**: MySQL
- **Security Group**: Allows access from EC2 instance.

### ElastiCache Redis
- **Node Type**: `cache.t2.micro`
- **Security Group**: Allows access from EC2 instance.

## Connecting to MySQL

1. SSH into the EC2 instance:
   ```bash
   ssh -i path/to/private_key.pem ec2-user@<EC2_PUBLIC_IP>
   ```

2. Use the following command to connect to the RDS database:
   ```bash
   mysql -h <RDS_ENDPOINT> -u admin -p<db_password> -D wordpress
   ```

Replace `<RDS_ENDPOINT>` with the RDS endpoint outputted by Terraform.

