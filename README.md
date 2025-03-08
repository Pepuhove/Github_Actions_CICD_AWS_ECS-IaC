**Node.js Hello World App Deployment on AWS (ECR + ECS Fargate) using Terraform & GitHub Actions**


**Overview**

This project demonstrates how to deploy a simple Node.js Hello World application on 
AWS ECS Fargate using Terraform for infrastructure provisioning and GitHub Actions for CI/CD automation. 
The app is containerized and stored in AWS ECR before being deployed to AWS ECS Fargate.

**Architecture**

AWS Elastic Container Registry (ECR): Stores the container image.

AWS ECS (Fargate): Runs the containerized Node.js app.

AWS Application Load Balancer (ALB): Directs traffic to the ECS service.

Terraform: Manages the infrastructure as code.

GitHub Actions: Automates building, pushing, and deploying the application.

Prerequisites

Before you begin, ensure you have the following:

AWS CLI installed and configured (aws configure)

Terraform installed (terraform -v)

Docker installed (docker -v)

GitHub Repository with GitHub Actions enabled

**Setup and Deployment**

1️⃣ Clone the Repository

git clone https://github.com/your-repo/nodejs-aws-fargate.git
cd nodejs-aws-fargate

2️⃣ Build & Push Docker Image to AWS ECR

Manually run these steps initially:

aws ecr create-repository --repository-name hello-world-app
$(aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <AWS_ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com)
docker build -t hello-world-app .
docker tag hello-world-app:latest <AWS_ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/hello-world-app:latest
docker push <AWS_ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/hello-world-app:latest

3️⃣ Deploy Infrastructure with Terraform

terraform init
terraform apply -auto-approve

This will:

Create an ECS Cluster

Define an ECS Task & Service

Configure an Application Load Balancer

Set up required IAM Roles & Security Groups

4️⃣ Configure GitHub Actions CI/CD

Add the following GitHub Secrets:

AWS_ACCESS_KEY_ID

AWS_SECRET_ACCESS_KEY

AWS_REGION

ECR_REGISTRY (<AWS_ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com)

ECR_REPOSITORY (hello-world-app)

GitHub Actions workflow (.github/workflows/deploy.yml):

name: Deploy to AWS ECS

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Code
        uses: actions/checkout@v3
      
      - name: Set up AWS Credentials
        uses: aws-actions/configure-aws-credentials@v2
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: ${{ secrets.AWS_REGION }}
      
      - name: Login to AWS ECR
        run: aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REGISTRY
      
      - name: Build and Push Docker Image
        run: |
          docker build -t $ECR_REGISTRY/$ECR_REPOSITORY:latest .
          docker push $ECR_REGISTRY/$ECR_REPOSITORY:latest
      
      - name: Deploy to ECS
        run: |
          aws ecs update-service --cluster my-app-cluster --service my-app --force-new-deployment

5️⃣ Access the Application

Once deployment is complete, retrieve the ALB DNS Name:

echo "http://$(terraform output alb_dns)"

Visit the URL in a browser to see "Hello, World!".

Cleanup

To delete all AWS resources:

terraform destroy -auto-approve

Technologies Used

AWS ECS (Fargate)

AWS ECR

Terraform

Docker

GitHub Actions

Node.js

Application Load Balancer (ALB)

Future Improvements

Add autoscaling for ECS tasks

Integrate CloudWatch Logging & Monitoring

Implement Blue-Green Deployment

🚀 Happy Deploying!
