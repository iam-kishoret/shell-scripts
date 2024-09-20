#!/bin/bash

##################
# Author: Kishore
# Date 22 Aug 2024
#
#Version: v1
#
#This script will report the AWS rsource usage
#################

set -x

# AWS S3
# AWS EC2
# AWS Lambda
# AWS IAM Users

# list s3 buckets
echo "Print list of s3 buckets"
aws s3 ls > resource_tracker 

# list EC2 instancesa
echo "Print list of EC2 instances"
aws ec2 describe-instances | jq '.Reservations[].Instances[].InstanceId' >> resource_tracker

# list lambda
echo "Print list of lambda functions"
aws lambda list-functions >> resource_tracker

# list aws IAM User
echo "Print list of IAM Users"
aws iam list-users | jq '.Users[].UserName' >> resource_tracker
