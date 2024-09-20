#!/bin/bash
###########################
#About: To import a public key generated from local machine to aws all regions 
#Pre-Req: Need to export your public key to the variable called "PUB_KEY_PATH"
#
#
#Author: Kishore Thotakoora
###########################

# Check if the public key file with path name was exported as variable "PUB_KEY_PATH" 
if [ -z "$PUB_KEY_PATH" ]; then
    echo "Error: Variable "PUB_KEY_PATH" is not set or is empty. Export failed. Please export your public key location with filename as "PUB_KEY_PATH""
    exit 1
else
    echo "Success: Variable "PUB_KEY_PATH" exist. proceeding to import public key into all the aws regions."
fi

# Define your key name and key file
KEY_NAME="my-public-key"
KEY_FILE=$PUB_KEY_PATH

# List of all AWS regions (you can modify this if needed)
REGIONS=$(aws ec2 describe-regions --query "Regions[].RegionName" --output text)

# Loop through all regions and import the key pair
for REGION in $REGIONS; do
    echo "Importing key pair into region: $REGION"

    # Import the key pair
    aws ec2 import-key-pair \
        --region $REGION \
        --key-name $KEY_NAME \
        --public-key-material fileb://$KEY_FILE

    if [ $? -eq 0 ]; then
        echo "Key pair imported successfully in $REGION."
    else
        echo "Failed to import key pair in $REGION."
    fi
done

echo "Key pair importation complete in all accessible regions."

