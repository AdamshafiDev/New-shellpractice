#!/bin/bash
START_TIME=(date +%s)
USERID=$(id -u)
R="\e[31m"s
G="\e[32m"
Y="\e[33m"
N="\e[0m"
LOG_FOLDER="/var/log/shelllogs.logs"
Script_name=$(echo $0 | cut -d "." -f1)
Log_file="$LOG_FOLDER/$Script_name.log"
#SCRIPT_DIR=$PWD

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

      cp mongo.repo /etc/yum.repos.d/mongodb.repo &>>$Log_file
      VALIDATE $? "copying mongodb repos"


     dnf install mongodb-org -y &>>$Log_file
     VALIDATE $? "Installing mongodb"


     systemctl enable mongod &>>$Log_file
     VALIDATE $? "enableing mongodb"

     systemctl start mongod &>>$Log_file
     VALIDATE  $? "starting mongodb"

     sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>>$Log_file
     VALIDATE $? "Editing for confiq file for remote connection"

     systemctl restart mongod &>>$Log_file
     VALIDATE $? "Restarted mongodb"

     END_TIME=$(date +%s)
    TOTAL_TIME=$(( $END_TIME - $START_TIME ))

echo -e "the script running succesfully:$G....Time taken $TOTAL_TIME secounds" | tee -a $Log_file

