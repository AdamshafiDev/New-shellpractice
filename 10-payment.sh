#!/bin/bash

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
echo "Script started at: $TIME_STAMP" | tee -a "$LOG_FILE"

# Root check
if [ "$USERID" -ne 0 ]; then
  echo -e "$R ERROR: please run the script with root access $N" | tee -a "$LOG_FILE"
  exit 1
else
  echo -e "$Y Script running with root access $N" | tee -a "$LOG_FILE"
fi

# Validate function
VALIDATE() {
  if [ "$1" -eq 0 ]; then
    echo -e "$2 is... $G SUCCESS $N" | tee -a "$LOG_FILE"
  else
    echo -e "$2 is... $R FAILURE $N" | tee -a "$LOG_FILE"
    exit 1
  fi
}

# Install packages
dnf install python3 gcc python3-devel -y &>>"$LOG_FILE"
VALIDATE $? "Installing Python3 packages"

# Create roboshop user if not exists
if ! id roboshop &>/dev/null; then
  useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>"$LOG_FILE"
  VALIDATE $? "Roboshop user creation"
else
  echo -e "$Y Roboshop user already exists... skipping $N" | tee -a "$LOG_FILE"
fi

# Create app directory
mkdir -p /app &>>"$LOG_FILE"
VALIDATE $? "Creating /app directory"

# Download application
curl -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment-v3.zip &>>"$LOG_FILE"
VALIDATE $? "Downloading payment artifact"

cd /app || exit 1
rm -rf /app/*

unzip /tmp/payment.zip &>>"$LOG_FILE"
VALIDATE $? "Unzipping payment application"

# Install dependencies
pip3 install -r requirements.txt &>>"$LOG_FILE"
VALIDATE $? "Installing Python dependencies"

# Set ownership
chown -R roboshop:roboshop /app

# Setup service
cp payment.service /etc/systemd/system/payment.service &>>"$LOG_FILE"
VALIDATE $? "Copying payment service file"

systemctl daemon-reload &>>"$LOG_FILE"
VALIDATE $? "Systemd daemon reload"

systemctl enable payment &>>"$LOG_FILE"
VALIDATE $? "Enabling payment service"

systemctl start payment &>>"$LOG_FILE"
VALIDATE $? "Starting payment service"

echo -e "$G Payment service deployed successfully $N" | tee -a "$LOG_FILE"
