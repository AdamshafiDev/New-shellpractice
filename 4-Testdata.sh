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
   
   dnf list installed nginx

     if [ $? - ne 0 ]
    then
       dnf install nginx -y
        echo "nginx is not install....Going to install now"
        VALIDATE $? "nginx"
        else
        echo "nginx is already installed ....nothing to do"
     fi

    dnf list installed mysql

     if [ $? - ne 0 ]
     then
       dnf install mysql -y
        echo "mysql is not install....Going to install now"
        VALIDATE $? "nginx"
        else
        echo "mysql is already installed ....nothing to do"


    fi
       

       dnf list installed httpd

     if [ $? - ne 0 ]
     then
       dnf install httpd -y
        echo "httpd is not install....Going to install now"
        VALIDATE $? "httpd"
        else
        echo "httpd is already installed ....nothing to do"


    fi



