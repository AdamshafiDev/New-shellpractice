#!/bin/bash

USERID=$(id -u )
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
#PACK=("nginx" "mysql" "python3" "httpd")

LOG_FOLDER=/var/log/shellscript.logs
SCRIPT_NAME=echo $0 | cut -d "." -f1
LOG_FILE="$LOG_FOLDER/$SCRIPT_NAME.log"

mkdir -p $LOG_FOLDER

echo  "the script started time:$(date)" | tee -a $LOG_FILE

if [ $USERID -ne 0 ]
then
  echo -e "$R ERROR:please run the script with root access" | tee -a $LOG_FILE
  exit 1
 else
  echo -e "$Y the script is running with root access" | tee -a $LOG_FILE
  fi

VALIDATE(){ 
    if [ $1 -eq 0 ]
     then
     echo "Installling $2...SUCCESSS" | tee -a $LOG_FILE
     else
     echo "installing $2 .....Failure" | tee -a $LOG_FILE
     exit 1
     fi
}

   #for pack in ${PACK[@]}
    for pack in $@

   do
    dnf list installed $pack
     if [ $? -ne 0 ]
    then
        echo "$pack is not install....Going to install now" | tee -a $LOG_FILE
        dnf install $pack -y
        VALIDATE $? "$pack"
    else
        echo -e  "$pack is already installed $G ....nothing to do" | tee -a $LOG_FILE
     fi

   done 
   
   