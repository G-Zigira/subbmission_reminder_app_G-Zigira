#!/bin/bash

# Figure out where this script is stored
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load the configuration and helper functions
source "$BASE_DIR/../config/config.env"
source "$BASE_DIR/../modules/functions.sh"

# Point to where the submissions file is located
submissions_file="$BASE_DIR/../assets/submissions.txt"

# Display current assignment info and run the reminder check
echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions "$submissions_file"
