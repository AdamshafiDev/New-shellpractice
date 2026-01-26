#!/bin/bash
START_TIME=$(date+%s)

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


dnf module disable redis -y &>>$Log_file
VVALIDATE $?  "Disbling redis"

dnf module enable redis:7 -y &>>$Log_file
VALIDATE $?  "enabling redisdb"

dnf install redis -y  &>>$Log_file
VALIDATE $? "Installing redis db"



sed -i -e 's/127.0.0.1/ 0.0.0.0/g' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf &>>$Log_file
VALIDATE $? "Edit the redis configureation to accept the remote connection"

systemctl enable redis &>>$Log_file
VALIDATE $? "enabling the redis db"

systemctl start redis &>>$Log_file
VALIDATE $? "srarting redis db"

END_TIME=$(date+%s)
TOTAL_TIME=$(( $END_TIME - $START_TIME ))

echo -e "The script excution successfully:$G ..Time taken seconds $TOTAL_TIME"