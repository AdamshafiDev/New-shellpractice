#!/bin/bash

USERID=$(id -u )
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

echo "the script started time:$(date)"

if [ $USERID -ne 0 ]
then
  echo "ERROR:please run the script with root access"
  exit 1
 else
  echo "the script is running with root access"
  fi

# VALIDATE()
# { 
#     if [ $1 -eq 0 ]
#      then
#      echo "Installling $2...SUCCESSS"
#      else
#      echo "installing $2 .....Failure"
#      exit 1
#      fi
# }


