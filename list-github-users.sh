#!/bin/bash

# GitHub API URL
API_URL="https://api.github.com"

# GitHub username and personal access token (make sure these are exported or set before running the script)
USERNAME="$GITHUB_USERNAME"
TOKEN="$GITHUB_TOKEN"

# User and Repository information
REPO_OWNER="$1"
REPO_NAME="$2"

# Function to make a GET request to the GitHub API
function github_api_get {
    local endpoint="$1"
    local url="${API_URL}/${endpoint}"

    # Send a GET request to the GitHub API with authentication
    curl -s -u "${USERNAME}:${TOKEN}" "$url"
}

# Function to list users with specific access to the repository
function list_users_with_access {
    local permission=$1
    local endpoint="repos/${REPO_OWNER}/${REPO_NAME}/collaborators"

    # Fetch the list of collaborators on the repository
    collaborators=$(github_api_get "$endpoint" | jq -r --arg perm "$permission" '.[] | select(.permissions[$perm] == true) | .login')

    # Display the list of collaborators with specified access
    if [[ -z "$collaborators" ]]; then
        print_color $CYAN "No users with $permission access found for ${REPO_OWNER}/${REPO_NAME}."
    else
        print_color $GREEN "========================================"
        print_color $RED "***** FOUND BELOW LIST OF USERS *****"
        print_color $GREEN "========================================" 
	print_color $MAGENTA "Users with $permission access to ${REPO_OWNER}/${REPO_NAME} is:"
        print_color $GREEN "$collaborators"
    fi
}

# Helper function to check command-line arguments
function helper {
    local expected_cmd_args=2
    if [[ $# -ne $expected_cmd_args ]]; then
        print_color $BLUE "This script will provide the list of users having chosen GitHub access type."
        print_color $RED "Please execute the script with the required command-line arguments as below:"
        print_color $CYAN "Argument 1: GitHub Repo Owner Name"
        print_color $CYAN "Argument 2: Repo name"
        print_color $MAGENTA "Also ensure you have exported GITHUB_USERNAME and GITHUB_TOKEN"
        exit 1
    fi
}

# Function to display the menu and take user input
function show_menu {
    print_color $GREEN "===================="
    echo "***MENU - CHOOSE AN OPTION TO LIST THE USERS HAVING GITHUB ACCESS***"
    print_color $GREEN "===================="
    echo "1. maintain"
    echo "2. push"
    echo "3. triage"
    echo "4. pull"
    echo "5. Exit the script"
    echo "===================="
    read -p "Please choose an option (1-5): " choice
}

# Function to display the menu for next selection
function next_menu {
    print_color $GREEN "===================="
    echo "***WANT TO CONTINUE SEARCH?***"
    print_color $GREEN "===================="
    echo "yes"
    print_color $BLUE "no"
    print_color $GREEN "===================="
    read -p "Please choose yes/no: " next_choice
}

# Function to process the selected option
function process_choice {
    case $choice in
        1)
            print_color $CYAN "You chose Option 1: maintain"
            list_users_with_access "admin"
            ;;
        2)
            print_color $CYAN "You chose Option 2: push"
            list_users_with_access "push"
            ;;
        3)
            print_color $CYAN "You chose Option 3: triage"
            list_users_with_access "triage"
            ;;
        4)
            print_color $CYAN "You chose Option 4: pull"
            list_users_with_access "pull"
            ;;
        5)
            print_color $MAGENTA "Exiting..."
            exit 0
            ;;
        *)
            print_color $RED "Invalid option. Please try again."
            ;;
    esac
}

# Function to print colored text
print_color() {
    local color_code=$1
    local text=$2
    local reset='\033[0m'  # Reset color

    echo -e "${color_code}${text}${reset}"
}

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'

# Validate command-line arguments before starting the menu loop
helper "$@"

# Main loop to show the menu and handle user choices
while true; do
    show_menu
    process_choice
    
    next_menu
    case $next_choice in
        yes)
            continue
            ;;
        no)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid option. Exiting..."
            exit 1
            ;;
    esac
done

