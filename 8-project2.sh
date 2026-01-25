#!/bin/bash
USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

mkdir -p $Log_file

LOG_FOLDER="/var/log/shelllogs.sh"
Script_name=($0)
Log_file="$LOG_FOLDER/$Script_name"

 TIME_STAMP=$(date)
  echo "the script start time$TIME_STAMP" | tee -a $Log_file

if [ $USERID -ne 0 ]
then
  echo -e "$$R ERROR: please run the script with  root access"
  exit 1
   else 

    echo -e "$Y the script running with root access"
 fi