#!/bin/bash

# Variables
AMI_ID="ami-04cdc91e49cb06165"          # Replace with your desired AMI ID
INSTANCE_TYPE="t3.micro"       # Replace with your desired instance type
KEY_NAME="my-toshiba-key"     # Replace with your key pair name
REGION_NAME="us-east-1"

# Create the EC2 instance
INSTANCE_ID=$(aws ec2 run-instances \
    --image-id $AMI_ID \
    --instance-type $INSTANCE_TYPE \
    --key-name $KEY_NAME \
    --region  $REGION_NAME \
    --count 1)

# Output the instance ID
echo "Created EC2 instance with Instance ID: $INSTANCE_ID"

# Wait for the instance to be in running state
echo "Waiting for instance to enter 'running' state..."
aws ec2 wait instance-running --instance-ids $INSTANCE_ID

# Get the public IP address of the instance
PUBLIC_IP=$(aws ec2 describe-instances \
    --instance-ids $INSTANCE_ID \
    --query "Reservations[0].Instances[0].PublicIpAddress" \
    --output text)

# Output the public IP address
echo "EC2 Instance Public IP: $PUBLIC_IP"

