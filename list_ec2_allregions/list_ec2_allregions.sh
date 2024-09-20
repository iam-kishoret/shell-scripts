#!/bin/bash

# Declare an associative array to store instance details
declare -A instances_by_region

# Get all regions
regions=$(aws ec2 describe-regions --output text | cut -f4)

# Loop through each region
for region in $regions
do
    echo -e "\nChecking Instances in region:'$region'..." >> log_list_ec2_instances.log
    # Get instance IDs and their statuses
    instances=$(aws ec2 describe-instances --region $region --query 'Reservations[*].Instances[*].[InstanceId,State.Name]' --output text)
    
    if [ -n "$instances" ]; then
        instances_by_region[$region]="$instances"
    else
        echo -e "\nNo instances found in region:'$region'. Skipping..." >> log_list_ec2_instances.log
    fi
done

# Output the instance details to standard output
echo -e "\nInstance IDs, Region, and Status:"
for region in "${!instances_by_region[@]}"
do
    echo -e "\nRegion: $region"
    echo "${instances_by_region[$region]}"
done

