#!/bin/bash

# This script starts up the submission reminder application.
# It also updates permissions for all .sh files before running the app,
# just to make sure everything can execute properly.

# Get the folder where this script lives
APP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Give all .sh files inside the app permission to run
find "$APP_DIR" -type f -name "*.sh" -exec chmod 755 {} \;

echo "Starting the submission reminder app..."
echo "----------------------------------------"

# This part of my code will run the reminder script
bash "$APP_DIR/app/reminder.sh"
