#!/bin/bash

USERID=$(id -u)
#TIME_STAMP=$(date)
 echo "the script started date::$TIME_STAMP"

if [ $USERID -ne 0 ]
then
   echo "ERROR:plese run the script with root access"
   exit 1
else
   echo "the script is running with root access"
fi