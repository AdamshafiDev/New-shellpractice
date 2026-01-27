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
    echo -e "$2 is....$G success $N" | tee -a $Log_file
     else 
     echo -e "$2 is.....$R failure $N"| tee -a $Log_file
     exit 1
     fi
   }


 dnf install python3 gcc python3-devel -y &>>$Log_file
 VALIDATE $? "Installing pyrhon3"



   id roboshop

  if [ $? -ne 0 ]
   then
        useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$Log_file
        VALIDATE $? "systemuser cerated"
  else
     echo -e "roboshop user already created....$Y skipping"
     fi


mkdir -p /app  &>>$Log_file
VALIDATE $? "Directory cerated"

curl -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment-v3.zip  &>>$Log_file
VALIDATE $? "downloading payment data"
 rm -rf /app/*
cd /app 

unzip /tmp/payment.zip &>>$Log_file
VALIDATE $? "unzipping foldercatalouge"


 pip3 install -r requirements.txt &>>$Log_file
 VALIDATE $? "Installing dependicies"

 cp payment.service /etc/systemd/system/payment.service &>>$Log_file
 VALIDATE $? "copying the "


systemctl daemon-reload &>>$Log_file
VALIDATE $? "Deamon reloaded"

systemctl enable payment  &>>$Log_file
VALIDATE $? "enableing payments"

systemctl start payment &>>$Log_file
VALIDATE $? "starting payments"