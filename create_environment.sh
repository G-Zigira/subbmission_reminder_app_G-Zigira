#!/bin/bash

# -------------------------------
# AUTHOR:G-Zigira
# create_environment.sh
# This script sets up the submission reminder app environment automatically.
# It creates all necessary folders and files, adds the provided source code,
# and gives proper permissions so everything runs smoothly.
# -------------------------------

# Ask the user for their name
read -p "Enter your name: " username

# Stop the script if the user didn't type a name
if [ -z "$username" ]; then
  echo "You must enter your name!"
  exit 1
fi

# Name of the main directory
folder_name="submission_reminder_${username}"

# Create the full directory structure
mkdir -p "$folder_name"/{app,modules,assets,config}

# -------------------------------
# Creating the config.env file
# -------------------------------
cat > "$folder_name/config/config.env" <<'EOF'
# This file stores key variables for the app
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
EOF

# -------------------------------
# Creating the submissions.txt file
# -------------------------------
cat > "$folder_name/assets/submissions.txt" <<'EOF'
student, assignment, submission status
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Divine, Shell Navigation, not submitted
Anissa, Shell Basics, submitted
EOF

# -------------------------------
# Creating the functions.sh file
# -------------------------------
cat > "$folder_name/modules/functions.sh" <<'EOF'
#!/bin/bash

# This function goes through the submissions list and prints out
# which students haven’t turned in their assignments yet.
function check_submissions {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file"

    # Skip the header line and go through each student
    while IFS=, read -r student assignment status; do
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)

        # Compare the assignment name and see if the student hasn't submitted
        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]]; then
            echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "$submissions_file")
}
EOF

# -------------------------------
# Creating the reminder.sh file
# -------------------------------
cat > "$folder_name/app/reminder.sh" <<'EOF'
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
EOF

# -------------------------------
# Creating the startup.sh file
# -------------------------------
cat > "$folder_name/startup.sh" <<'EOF'
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
EOF

# -------------------------------
# Final setup and permissions
# -------------------------------
# Give execution permission to every .sh file we just created
find "$folder_name" -type f -name "*.sh" -exec chmod 755 {} \;

echo "Your Environment was created successfully!"
echo "------------------------------------"
echo "Directory created: $folder_name"
echo "All scripts have been given proper permissions (755)."
echo "To start the reminder app, run:"
echo "bash $folder_name/startup.sh"
