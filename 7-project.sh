#!/bin/bash

USERID=$(id -u)
TIME_STAMP=$(date)
PACKAGE=("mysql" "nginx" "nodejs")
LOG_FOLDER="/var/log/shellscript.log"
SCRIPT_NAME="$0 | cut -d "." -f1"
LOG_FILE="$LOG_FOLDER/$SCRIPT_NAME.log"

 mkdir -p $LOG_FOLDER

 echo -e "the script started date::$TIME_STAMP" | tee -a $LOG_FILE

if [ $USERID -ne 0 ]
then
   echo "ERROR:plese run the script with root access" 
   exit 1
else
   echo "the script is running with root access" 
fi
   
   VALIDATE(){

        if [ $1 -eq 0 ]
        then
          echo "Installing package:$2.....successs" 
        else
          echo "Installing package:$2.....Failure"  
          exit 1
         fi 
   }

   for cover in ${PACKAGE[@]}
   do
      dnf list installed mysql 
       if [ $? -ne 0 ]
       then
          echo "$cover is not install going to install now" 
          dnf install $cover -y 
          VALIDATE $? "$cover"
       else
          echo "$cover is install ..Nothing to do" 
       fi
   done
     