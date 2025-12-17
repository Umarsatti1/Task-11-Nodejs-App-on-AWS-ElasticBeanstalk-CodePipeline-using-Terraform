# Deploying a Three-Tier Application on AWS Elastic Beanstalk with CodePipeline using Terraform

---

## Task Description

This project demonstrates the deployment of a **three-tier e-commerce application** using **React (frontend)**, **Node.js & Express (backend)**, and an external **MySQL RDS database**, fully automated with **Terraform** and **CI/CD using AWS CodePipeline and CodeBuild**.

The application is deployed in a **single Elastic Beanstalk environment**, where the React frontend is built and packaged inside the backend build directory. Terraform provisions a secure and production-ready AWS infrastructure, including networking, IAM, compute, database, CI/CD, monitoring, logging, and alerting.

Key objectives include:
- Infrastructure provisioning using Terraform modules
- Secure VPC design with public, private, and database subnets
- External MySQL RDS integration
- Automated CI/CD pipeline using CodePipeline and CodeBuild
- Monitoring and alerting with CloudWatch and SNS
- Auto Scaling validation using CPU and memory-based alarms

---

## Architecture Diagram

<p align="center">
  <img src="./diagram/Architecture Diagram.png" alt="Architecture Diagram" width="900">
</p>

---

## 1. Test Application Locally

Before deploying to AWS, the three-tier application is tested locally to ensure proper interaction between frontend, backend, and database layers.

### 1.1 Files Overview

**Backend (Node.js / Express)**
- **app.js** – Main server file; configures middleware, API routes, authentication, and serves the React build.
- **package.json** – Project metadata, dependencies, and scripts.
- **database/connection.js** – MySQL connection using mysql2 with pooling and promise support.

**Frontend (React)**
- Located in `client/`
- Runs locally on port 3000
- Built using `npm run build` and copied into the backend for production

**Application Features**
- User registration and login (JWT authentication)
- Products, cart, and orders
- Role-based access (admin and normal users)

**Database Schema**
- Five tables: users, product, shoppingCart, orders, productsInOrder
- Foreign keys enforce relationships
- Supports CRUD operations

### 1.2 Local Test Steps

```bash
# Backend
cd server
npm install
node app.js

# Frontend
cd client
npm install
npm start
```

- Frontend: http://localhost:3000
- Backend: http://localhost:8080 OR http://localhost:3001
- Verify database connectivity using MySQL Workbench
- Test registration, login, products, cart, and orders

---

## 2. S3 Bucket for Terraform Remote Backend

An S3 bucket is used for centralized Terraform state management.

**Steps:**
1. AWS Console → S3 → Create Bucket
2. Choose a unique name and region (us-west-1)
3. Update `terraform.tf` backend configuration

**Benefits:**
- Centralized and secure Terraform state
- State locking to prevent concurrent updates

**Example Path:**
```
umarsatti-terraform-state-file-s3-bucket-sandbox/Task-11/terraform.tfstate
```

---

## 3. Project Structure

The project is organized into application code, Terraform infrastructure, and CI/CD configuration.

### 3.1 .ebextensions
- Contains `cloudwatch.config`
- Installs and configures CloudWatch Agent
- Enables memory metrics and log streaming

### 3.2 Application Structure

```
client/        # React frontend
server/        # Node.js backend
 ├─ app.js
 ├─ package.json
 ├─ build/     # React build copied here
 ├─ database/
 └─ routes/
```

### 3.3 buildspec.yml

Defines CodeBuild steps:
- Install frontend and backend dependencies
- Build React frontend
- Copy build into backend
- Package backend with `.ebextensions`
- Output artifact for Elastic Beanstalk

### 3.4 Terraform Root Files

- **main.tf** – Orchestrates all modules
- **terraform.tf** – AWS provider and S3 backend
- **variables.tf** – Input variable definitions
- **terraform.tfvars** – Environment-specific values
- **outputs.tf** – Exposes VPC ID and Application URL
- **IAM JSON policies** – Permissions for EB, EC2, CodeBuild, CodePipeline

### 3.5 Terraform Modules

- **VPC Module** – Networking, subnets, routing, NAT, SGs
- **IAM Module** – Roles and instance profiles
- **RDS Module** – MySQL database in private subnets
- **Elastic Beanstalk Module** – App, environment, scaling, monitoring
- **CodeBuild Module** – Build stage configuration
- **CodePipeline Module** – Source → Build → Deploy workflow

---

## 4. Execute Terraform Commands

Run from the Terraform root directory:

```bash
terraform init
terraform validate
terraform plan
terraform apply --auto-approve
```

**Resources Deployed:**
- VPC, subnets, IGW, NAT gateways
- Security groups (ALB, EC2, RDS)
- IAM roles and instance profiles
- RDS MySQL instance
- Elastic Beanstalk application & environment
- ALB and Auto Scaling Group
- CloudWatch logs and alarms
- SNS notifications
- CodeBuild and CodePipeline

---

## 5. Validate Infrastructure in AWS Console

Validation steps include:
- **VPC & Networking:** CIDR, subnets, routes, gateways
- **IAM:** EB service role, EC2 instance profile, CI/CD roles
- **RDS:** MySQL instance and subnet group
- **Elastic Beanstalk:** Application, environment health, URL
- **EC2 & ALB:** Instances, target groups, ASG
- **S3:** Artifact and pipeline buckets
- **CloudWatch & SNS:** Logs, alarms, subscriptions
- **CodeBuild & CodePipeline:** Successful executions

---

## 6. Application Testing, Alarms, and Auto Scaling

### 6.1 Database Setup via EC2

- Connect to EB EC2 instance using Session Manager
- Install MySQL client
- Connect to RDS endpoint
- Execute `createTables.sql`
- Verify tables using `SHOW TABLES;`

### 6.2 CloudWatch Logs

Key logs reviewed:
- **CodeBuild logs** – Successful build
- **/var/log/eb-engine.log** – EB deployment lifecycle
- **/var/log/web.stdout.log** – App startup and DB connection
- **NGINX logs** – Request routing validation

### 6.3 Application Testing

- Open Elastic Beanstalk environment URL
- Verify UI loads successfully
- Test registration, login, products, cart, and orders

### 6.4 SNS Email Subscriptions

- Confirm CPU and Memory alarm subscriptions via email

### 6.5 CloudWatch Agent Verification

```bash
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -m ec2 -a status
sudo cat /opt/aws/amazon-cloudwatch-agent/bin/config.json
```

### 6.6 Trigger Alarms

```bash
# CPU
stress-ng --cpu 0 --cpu-load 90 --timeout 300

# Memory
stress-ng --vm 1 --vm-bytes 2500M --vm-keep --timeout 240
```

- Verify alarms transition OK → ALARM
- Confirm ASG scale-out and scale-in events
- Validate SNS email notifications

---

## 7. Clean Up

Destroy all resources to avoid charges:

```bash
terraform destroy --auto-approve
```

---

## 8. Troubleshooting

Common issues addressed during deployment:

- Missing EC2 and EB permissions in CodePipeline
- Incorrect CodeBuild image
- IAM policy duplication
- Improper artifact packaging
- Database connectivity issues
- Frontend API routing misconfiguration
- MySQL promise pool misusage

Each issue was resolved by adjusting IAM policies, Terraform configuration, buildspec logic, or application code.

---

