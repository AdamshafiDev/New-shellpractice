#!/bin/bash

START_TIME=$(date +%s)

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOG_FOLDER="/var/log/shelllogs"
SCRIPT_NAME=$(basename "$0" .sh)
LOG_FILE="$LOG_FOLDER/$SCRIPT_NAME.log"

mkdir -p "$LOG_FOLDER"

TIME_STAMP=$(date)
echo "The script start time: $TIME_STAMP" | tee -a "$LOG_FILE"

# Root check
if [ "$USERID" -ne 0 ]; then
  echo -e "$R ERROR: please run the script with root access $N" | tee -a "$LOG_FILE"
  exit 1
else
  echo -e "$Y Script running with root access $N" | tee -a "$LOG_FILE"
fi

# Read password securely
echo "Enter RabbitMQ password:"
read -s RABBITMQ_PASSWORD
echo

# Validate function
VALIDATE() {
  if [ "$1" -eq 0 ]; then
    echo -e "$2 is... $G SUCCESS $N" | tee -a "$LOG_FILE"
  else
    echo -e "$2 is... $R FAILURE $N" | tee -a "$LOG_FILE"
    exit 1
  fi
}

# Copy repo
cp rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo &>>"$LOG_FILE"
VALIDATE $? "Copying RabbitMQ repo"

# Install RabbitMQ
dnf install rabbitmq-server -y &>>"$LOG_FILE"
VALIDATE $? "Installing RabbitMQ"

# Enable service
systemctl enable rabbitmq-server &>>"$LOG_FILE"
VALIDATE $? "Enabling RabbitMQ"

# Start service
systemctl start rabbitmq-server &>>"$LOG_FILE"
VALIDATE $? "Starting RabbitMQ"

# Create user
rabbitmqctl add_user roboshop "$RABBITMQ_PASSWORD" &>>"$LOG_FILE"
VALIDATE $? "Creating RabbitMQ user"

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>"$LOG_FILE"
VALIDATE $? "Setting RabbitMQ permissions"

END_TIME=$(date +%s)
TOTAL_TIME=$((END_TIME - START_TIME))

echo -e "$G Script executed successfully. Time taken: $TOTAL_TIME seconds $N" | tee -a "$LOG_FILE"
