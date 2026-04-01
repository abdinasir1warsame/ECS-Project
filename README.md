# Memos on AWS ECS Fargate

Production-grade deployment of Memos, an open-source and privacy-focused
note-taking platform, using AWS cloud services, Infrastructure as Code,
and CI/CD automation.

**Live Demo:** https://memos-app-ecs.com

---

## Overview

This project deploys Memos into AWS as a secure, scalable, and
highly-available platform using modern DevOps practices.

### Three-Tier Architecture

- **Presentation Tier** -- Application Load Balancer (ALB) with HTTPS
  termination\
- **Application Tier** -- ECS Fargate tasks running the Memos
  container (frontend + backend)\
- **Data Tier** -- Amazon RDS PostgreSQL (or optionally SQLite with
  persistent volume)

Everything is provisioned using Terraform and deployed via GitHub
Actions CI/CD pipeline.

---

## Architecture

![Architecture Diagram](./images/Diagram.jpg)

### Key Network Design

- VPC with public subnets (for ALB) and private subnets (for ECS tasks
  & RDS)
- Security groups enforce strict traffic flow: Internet → ALB → ECS
  tasks → RDS
- VPC Endpoints for ECR, S3, CloudWatch Logs (no NAT Gateway required)

---

## Key Features

- Infrastructure as Code -- Entire AWS environment defined in
  Terraform modules
- Multi-Stage Docker Builds -- Optimized images (\~200MB) with layer
  caching
- Non-Root Containers -- All services run as non-privileged users
- Internal Backend -- Backend services have no public exposure
- Secrets Management -- Database credentials stored in AWS Secrets
  Manager
- State Locking -- S3 backend + DynamoDB for safe concurrent Terraform
  operations
- Automated CI/CD -- GitHub Actions with OIDC authentication
- High Availability -- Multi-AZ deployment, auto-healing ECS service

---

## Repository Structure

    memos-ecs-project/
    ├── docker/
    │   ├── frontend.Dockerfile
    │   ├── backend.Dockerfile
    │   └── nginx.conf
    ├── terraform/
    │   ├── main.tf
    │   ├── provider.tf
    │   ├── secrets.tf
    │   ├── variables.tf
    │   ├── outputs.tf
    │   └── modules/
    │       ├── vpc/
    │       ├── security-groups/
    │       ├── iam/
    │       ├── ecr/
    │       ├── rds/
    │       ├── alb/
    │       ├── ecs-cluster/
    │       ├── ecs/
    │       ├── ecs-service/
    │       └── route-53/
    ├── .github/
    │   └── workflows/
    │       ├── deploy.yml
    │       ├── apply.yml
    │       ├── health-check.yml
    │       └── destroy.yml
    ├── docker-compose.yml
    └── README.md

---

## Local Development

### Prerequisites

- Docker Desktop
- Node.js 20+ (optional)
- Go 1.25+ (optional)

### Run with Docker Compose

```bash
git clone https://github.com/your-org/memos-ecs-project.git
cd memos-ecs-project
docker-compose up
```

Access at: http://localhost

---

## Infrastructure Components (Terraform)

Module Description

---

vpc VPC (10.0.0.0/16), public/private subnets across 2 AZs
security-groups Separate SGs with least-privilege rules
iam ECS execution & service roles
ecr ECR repositories
rds PostgreSQL in private subnets
alb Public frontend ALB + internal backend ALB
ecs-cluster ECS Fargate cluster
ecs Task definitions
ecs-service ECS services with health checks
route-53 DNS A record + ACM certificate

---

## State Management

- S3 bucket for remote Terraform state (versioning enabled)
- DynamoDB table for state locking

---

## CI/CD Pipeline

### Workflows

- **apply.yml** -- Terraform init → validate → plan → apply
- **deploy.yml** -- Build Docker images, scan with Trivy, push to ECR
- **health-check.yml** -- Validate live endpoint
- **destroy.yml** -- Tear down infrastructure

---

## Deployment Guide

### Step 1: Bootstrap State Backend

```bash
aws s3api create-bucket --bucket memos-tf-state --region eu-west-2 --create-bucket-configuration LocationConstraint=eu-west-2
aws s3api put-bucket-versioning --bucket memos-tf-state --versioning-configuration Status=Enabled
aws dynamodb create-table --table-name terraform-locks --attribute-definitions AttributeName=LockID,AttributeType=S --key-schema AttributeName=LockID,KeyType=HASH --billing-mode PAY_PER_REQUEST
```

### Step 2: Store Secrets

```bash
aws secretsmanager create-secret  --name prod/memos/db  --secret-string '{"db_name":"memosdb","username":"memos_user","password":"SecurePassword123!","port":5432}'
```

### Step 3: Configure GitHub Secrets

- AWS_OIDC_ROLE_ARN
- SNYK_TOKEN (optional)

### Step 4: Deploy Infrastructure

Trigger `apply.yml` manually in GitHub Actions.

### Step 5: Verify

Visit: https://memos-app-ecs.com

---

## Troubleshooting

---

Issue Possible Cause Solution

---

ECS tasks not Missing secrets/IAM Check CloudWatch logs
starting

ALB targets Health check misconfig Ensure correct path &
unhealthy SG rules

gRPC-web fails Nginx config Verify proxy_method
setting

Certificate not DNS validation missing Check Route 53
validating

Terraform state Lock held Release from DynamoDB
lock

---

---

## Lessons Learned

- Separation of infra and app deployments
- VPC endpoints reduce NAT costs
- Non-root containers improve security
- gRPC-web requires special Nginx config
- State locking prevents conflicts

---

## Tech Stack

- Cloud: AWS (ECS, ECR, ALB, VPC, RDS, Route 53, ACM, S3, DynamoDB,
  CloudWatch)
- IaC: Terraform
- Containers: Docker
- CI/CD: GitHub Actions + OIDC
- Backend: Go
- Frontend: React + Nginx
- Database: PostgreSQL
