#!/bin/bash
USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

if [ $USERID -ne 0 ]
then
  echo -e  "$$R ERROR: please run the script with  root access"
  exit 1
   else 

    echo "$Y the script running with root access"
 fi