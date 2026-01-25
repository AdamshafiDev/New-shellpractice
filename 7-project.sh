#!/bin/bash

USERID=$(id -u)
TIME_STAMP=$(date)
Pack=("Mysql" "nginx" "nodejs")
 echo "the script started date::$TIME_STAMP"

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
   }

   dnf  list installed mysql
   
     for Pack  in ( $Pack[@])
     do
       echo "$pack is not install going to install"
       dnf install $pack -y
       Validate $? "mysql"
       
       done