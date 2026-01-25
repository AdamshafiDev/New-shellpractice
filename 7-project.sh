#!/bin/bash

USERID=$(id -u)
TIME_STAMP=$(date)
PACKAGE=("mysql" "nginx" "nodejs")
LOG_FOLDER="/var/log/shellscript.log"
SCRIPT_NAME="$0 | cut -d "." -f1"
LOG_FILE="$LOG_FOLDER/$SCRIPT_NAME.log"

 mkdir -p $LOG_FOLDER

 echo "the script started date::$TIME_STAMP" &>>LOG_FILE

if [ $USERID -ne 0 ]
then
   echo "ERROR:plese run the script with root access" &>>LOG_FILE
   exit 1
else
   echo "the script is running with root access" &>>LOG_FILE
fi
   
   VALIDATE(){

        if [ $1 -eq 0 ]
        then
          echo "Installing package:$2.....successs" &>>LOG_FILE
        else
          echo "Installing package:$2.....Failure"  &>>LOG_FILE
          exit 1
         fi 
   }

   for cover in ${PACKAGE[@]}
   do
      dnf list installed mysql &>>LOG_FILE
       if [ $? -ne 0 ]
       then
          echo "$cover is not install going to install now" &>>LOG_FILE
          dnf install $cover -y &>>LOG_FILE
          VALIDATE $? "$cover"
       else
          echo "$cover is install ..Nothing to do" &>>LOG_FILE
       fi
   done
     