#!/bin/bash

START_TIME=$(date +%s)

USERID=$(id -u)
R="\e[31m"s
G="\e[32m"
Y="\e[33m"
N="\e[0m"
LOG_FOLDER="/var/log/shelllog.logs"
Script_name=$(echo $0 | cut -d "." -f1)
Log_file="$LOG_FOLDER/$Script_name.log"
SCRIPT_DIR=$PWD

 mkdir -p $LOG_FOLDER

 TIME_STAMP=$(date)
  echo "the script start time$TIME_STAMP" | tee -a $Log_file

if [ $USERID -ne 0 ]
then
  echo -e "$$R ERROR: please run the script with  root access" | tee -a $Log_file
  exit 1
   else 
   echo -e "$Y the script running with root access" | tee -a $Log_file
 fi

   VALIDATE(){
    if [ $1 -eq 0 ]
    then
    echo -e "$2 is....$G success $N" | tee -a $Log_file
     else 
     echo -e "$2 is.....$R failure $N"| tee -a $Log_file
     exit 1
     fi
   }



dnf module disable nodejs -y &>>$Log_file
VALIDATE $? "Disbling nodejs"

dnf module enable nodejs:20 -y &>>$Log_file
VALIDATE $? "enabled nodejs:20"


dnf install nodejs -y &>>$Log_file
VALIDATE $? "Installing nodejs"

id roboshop

  if [ $? -ne 0 ]
   then
        useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$Log_file
        VALIDATE $? "systemuser created"
  else
     echo -e "roboshop user already created....$Y skipping"
     fi


mkdir -p /app  &>>$Log_file
VALIDATE $? "Directory cerated"

curl -L -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart-v3.zip  &>>$Log_file
VALIDATE $? "downloading cart data"

 rm -rf /app/*
cd /app 

unzip /tmp/cart.zip &>>$Log_file
VALIDATE $? "unzipping foldercatalouge"

npm install &>>$Log_file
VALIDATE $? "Installing dependency"

cp $SCRIPT_DIR/cart.service /etc/systemd/system/cart.service &>>$Log_file
VALIDATE $? "copying cart services"

systemctl daemon-reload &>>$Log_file
VALIDATE $? "deamon-reload"

systemctl enable cart  &>>$Log_file
VALIDATE $? "enableing cart"

systemctl start cart &>>$Log_file
VALIDATE $? "started cart"

systemctl status cart &>>$Log_file
VALIDATE $? "status of  cart"

END_TIME=$(date +%s)
TOTAL_TIME=$(( $END_TIME - $START_TIME ))

echo -e "the script running succesfully:$G....Time taken $TOTAL_TIME secounds"









