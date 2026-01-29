#!/bin/bash

START_TIME=$(date +%s)


USERID=$(id -u)
R="\e[31m"
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
  echo -e "$R ERROR: please run the script with  root access" | tee -a $Log_file
  exit 1
   else 
   echo -e "$Y the script running with root access" | tee -a $Log_file
 fi
  
 echo "enter the root password"
 read -s RABBITMQ_PASSWORD

  VALIDATE(){

    if [ $1 -eq 0 ]
    then
    echo -e "$2 is....$G success $N" | tee -a $Log_file
     else 
     echo -e "$2 is.....$R failure $N"| tee -a $Log_file
     exit 1
     fi
   }

cp rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo &>>$Log_file
VALIDATE "copying rabbitmq repo"

dnf install rabbitmq-server -y &>>$Log_file
VALIDATE $? "Installing rabbit mq"

systemctl enable rabbitmq-server &>>$Log_file
VALIDATE $? "Enableing rabbitmq"

systemctl start rabbitmq-server &>>$Log_file
VALIDATE $? "staring rabbitmq"


rabbitmqctl add_user roboshop $RABBITMQ_PASSWORD &>>$Log_file
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"


END_TIME=$(date +%s)
TOTAL_TIME=$(( $END_TIME - $START_TIME ))

echo -e "the script running succesfully:$G....Time taken $TOTAL_TIME secounds" | tee -a $Log_file

