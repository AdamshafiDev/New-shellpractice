#!/bin/bash
USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"



LOG_FOLDER="/var/log/shelllogs.sh"
Script_name=$(echo $0 | cut -d "." -f1)
Log_file="$LOG_FOLDER/$Script_name.log"
pack=("nginx" "mysql" "nodejs")

 mkdir -p $Log_file

 TIME_STAMP=$(date)
  echo "the script start time$TIME_STAMP" 

if [ $USERID -ne 0 ]
then
  echo -e "$$R ERROR: please run the script with  root access"
  exit 1
   else 
   echo -e "$Y the script running with root access"
 fi

   VALIDATE()
   {
    if [ $1 -eq 0 ]
    then
    echo -e "$Y Installing $2.....$G success"
     else 
     echo -e "$Y Installing $2......$R failure"
     exit 1
     fi
   }

    for cover in ${$pack[@]}
    do
            dnf list installed $cover
              if [ $? -ne 0 ]
               then

               echo "$cover is not insall...going to inatall now"
                dnf install $cover -y
                VALIDATE $? "$cover"
                else
            echo " $cover is already installed nothing to do"
                fi

    done