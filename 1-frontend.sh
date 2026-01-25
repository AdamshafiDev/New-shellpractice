#!/bin/bash

USERID=$(id -u)
R="\e[31m"s
G="\e[32m"
Y="\e[33m"
N="\e[0m"
LOG_FOLDER="/var/log/shelllogs.logs"
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
    echo -e "$2 is....$G success" | tee -a $Log_file
     else 
     echo -e "$2 is.....$R failure"| tee -a $Log_file
     exit 1
     fi
   }

     dnf module list nginx &>>$Log_file
     VALIDATE $? "Nginx is module display"

    dnf module disable nginx -y &>>$Log_file
    VALIDATE $? "disablling nginx"

    dnf  module enable nginx:1.24 -y &>>$Log_file
    VALIDATE $? "enableing nginx:1.24"

    dnf install nginx -y &>>$Log_file
    VALIDATE $? "nginx is installed"

    systemctl enable nginx &>>$Log_file
    VALIDATE $? "nginx is enabled"

    systemctl start nginx &>>$Log_file
    VALIDATE $? "nginx server started"
    systemctl status nginx &>>$Log_file
    VALIDATE $? "nginx is active and running fine"

    rm -rf /usr/share/nginx/html/*  &>>$Log_file
    VALIDATE $? "removeing old data"

    curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip &>>$Log_file
    VALIDATE $? "download fronend data"

    cd /usr/share/nginx/html 
    unzip /tmp/frontend.zip &>>$Log_file
    VALIDATE $? "unzipping fronend data"

    rm -rf /etc/nginx/nginx.conf &>>$Log_file
    VALIDATE $? "Removing the default content"
    

    cp $SCRIPT_DIR/nginx.conf /etc/nginx/nginx.conf
    VALIDATE $? "copying the nginx confiq data"

    systemctl restart nginx &>>$Log_file
    VALIDATE $? "nginx sever restarted"


