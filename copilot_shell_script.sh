#!/bin/bash

# AUTHOR:G-Zigira
# This script helps me update the assignment name in the reminder app
# without having to manually open the config file.

# First, I’ll locate the folder that starts with submission_reminder_
folder=$(find . -type d -name "submission_reminder_*" | head -n 1)

# Check if the folder exists
if [ -z "$folder" ]; then
  echo "I couldn’t find the submission_reminder_ folder. Please run create_environment.sh first."
  exit 1
else
  echo "Found project directory: $folder"
fi

# Point to the config file inside that folder
CONFIG="$folder/config/config.env"

# Make sure the config file actually exists
if [ ! -f "$CONFIG" ]; then
  echo "Config file not found inside $folder/config/"
  exit 1
fi

# Ask the user for the new assignment name
read -p "Enter the new assignment name: " new_assignment

# Stop if nothing was typed
if [ -z "$new_assignment" ]; then
  echo "You must enter an assignment name!"
  exit 1
fi

# This section replaces the current assignment in config.env
# It looks for the ASSIGNMENT= line and updates it with what I just typed
sed -i "s/^ASSIGNMENT=.*/ASSIGNMENT=\"$new_assignment\"/" "$CONFIG"

echo "Assignment name has been updated to: $new_assignment"
echo "--------------------------------------------"

# Now I’ll run the startup script inside the project folder
bash "$folder/startup.sh"

