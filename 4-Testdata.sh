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

VALIDATE()
{ 
    if [ $1 -eq 0 ]
     then
     echo "Installling $2...SUCCESSS"
     else
     echo "installing $2 .....Failure"
     exit 1
     fi
}

dnf list  installed nginx

if [ $? - ne 0 ]
 then
 echo "nginx is not install.....going to install now"
 dnf install nginx -y
 VALIDATE $? "nginx"
 else 
  echo "nginx is already installed ...Nothing to do"
  fi

dnf list  installed python3

if [ $? - ne 0 ]
 then
 echo "python3 is not install.....going to install now"
 dnf install python3 -y
 VALIDATE $? "python3"
 else 
  echo "python3 is already installed ...Nothing to do"
  fi

