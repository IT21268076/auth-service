#!/bin/bash

# Script to deploy AWS resources using CloudFormation

# Set variables
AWS_REGION="us-east-1"
STACK_NAME="auth-service-stack"
TEMPLATE_FILE="cloudformation/ecs-cluster.yml"
VPC_ID=$(aws ec2 describe-vpcs --query "Vpcs[0].VpcId" --output text)
SUBNETS=$(aws ec2 describe-subnets --query "Subnets[?MapPublicIpOnLaunch==\`true\`].SubnetId" --output text | tr '\t' ',')

# Create ECR repository if it doesn't exist
echo "Creating ECR repository if it doesn't exist..."
aws ecr describe-repositories --repository-names auth-service --region $AWS_REGION || \
    aws ecr create-repository --repository-name auth-service --region $AWS_REGION

# Deploy CloudFormation stack
echo "Deploying CloudFormation stack..."
aws cloudformation deploy \
    --template-file $TEMPLATE_FILE \
    --stack-name $STACK_NAME \
    --parameter-overrides \
        VpcId=$VPC_ID \
        Subnets=$SUBNETS \
        ContainerPort=8080 \
        ImageTag=latest \
    --capabilities CAPABILITY_NAMED_IAM \
    --region $AWS_REGION

# Check if deployment was successful
if [ $? -eq 0 ]; then
    echo "CloudFormation stack deployed successfully!"
    # Get the service URL
    SERVICE_URL=$(aws cloudformation describe-stacks --stack-name $STACK_NAME --query "Stacks[0].Outputs[?OutputKey=='ServiceUrl'].OutputValue" --output text --region $AWS_REGION)
    echo "Auth Service is available at: http://$SERVICE_URL"
else
    echo "CloudFormation stack deployment failed!"
    exit 1
fi

#Execuet commad
#chmod +x scripts/deploy-aws.sh