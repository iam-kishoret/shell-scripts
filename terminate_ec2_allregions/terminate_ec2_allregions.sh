#!/bin/bash

# Declare an associative array to store instance details
declare -A instances_by_region

# Redirect all script output to a log file
exec > terminate_ec2_allregions.output 2>&1

# Get all regions
regions=$(aws ec2 describe-regions --output text | cut -f4)

# Loop through each region
for region in $regions
do
    echo -e "\nChecking Instances in region:'$region'..."
    # Get instance IDs and their statuses
    instances=$(aws ec2 describe-instances --region $region --query 'Reservations[*].Instances[*].[InstanceId,State.Name]' --output text)
    
    if [ -n "$instances" ]; then
        instances_by_region[$region]="$instances"
    else
        echo -e "\nNo instances found in region:'$region'. Skipping..."
    fi
done

# Output the instance details to standard output in a readable format
exec > /dev/tty 2>&1
echo -e "\nInstance IDs, Region, and Status:"
for region in "${!instances_by_region[@]}"
do
    echo -e "\nRegion: $region"
    echo -e "Instance ID\t\tStatus"
    echo "${instances_by_region[$region]}" | while read -r instance_id status; do
        printf "%-20s %s\n" "$instance_id" "$status"
    done
done

# Stop the instances
for region in "${!instances_by_region[@]}"
do
    echo -e "\nStopping instances in region:'$region'..."
    echo "${instances_by_region[$region]}" | while read -r instance_id status; do
        aws ec2 stop-instances --region $region --instance-ids $instance_id
    done
done

# Wait for instances to stop
for region in "${!instances_by_region[@]}"
do
    echo -e "\nWaiting for instances to stop in region:'$region'..."
    echo "${instances_by_region[$region]}" | while read -r instance_id status; do
        aws ec2 wait instance-stopped --region $region --instance-ids $instance_id
    done
done

# Terminate the instances
for region in "${!instances_by_region[@]}"
do
    echo -e "\nTerminating instances in region:'$region'..."
    echo "${instances_by_region[$region]}" | while read -r instance_id status; do
        aws ec2 terminate-instances --region $region --instance-ids $instance_id
    done
done

