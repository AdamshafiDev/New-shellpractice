#!/bin/bash
USERID=$(id -u)
R="\e[31m"s
G="\e[32m"
Y="\e[33m"
N="\e[0m"
LOG_FOLDER="/var/log/shelllogs.logs"
Script_name=$(echo $0 | cut -d "." -f1)
Log_file="$LOG_FOLDER/$Script_name.log"
pack=("nginx" "mysql" "nodejs")

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

   VALIDATE()
   {
    if [ $1 -eq 0 ]
    then
    echo -e "$Y Installing $2.....$G success" | tee -a $Log_file
     else 
     echo -e "$Y Installing $2......$R failure"| tee -a $Log_file
     exit 1
     fi
   }

    for cover in ${pack[@]}
    do
            dnf list installed $cover &>>$Log_file
              if [ $? -ne 0 ]
               then

               echo "$cover is not insall...going to inatall now" | tee -a $Log_file
                dnf install $cover -y &>>$Log_file
                VALIDATE $? "$cover"
                else
            echo " $cover is already installed nothing to do" | tee -a $Log_file
                fi

    done
    echo "the script end time:" $date