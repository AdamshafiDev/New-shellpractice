#!/bin/bash

START_TIME=$(date +%s)

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

  echo "enter the root password"
   read -s MYSQL_ROOT_PASSWORD

   VALIDATE(){
    if [ $1 -eq 0 ]
    then
    echo -e "$2 is....$G success $N" | tee -a $Log_file
     else 
     echo -e "$2 is.....$R failure $N"| tee -a $Log_file
     exit 1
     fi
   }


 dnf install maven -y &>>$Log_file
 VALIDATE $? "Installing maven and java"

 id roboshop

  if [ $? -ne 0 ]
   then
        useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$Log_file
        VALIDATE $? "systemuser cerated"
  else
     echo -e "roboshop user already created....$Y skipping"
     fi


mkdir -p /app  &>>$Log_file
VALIDATE $? "Directory cerated"

curl -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping-v3.zip  &>>$Log_file
VALIDATE $? "downloading catalouge data"

rm -rf /app/* &>>$Log_file
cd /app 

unzip /tmp/shipping.zip &>>$Log_file
VALIDATE $? "unzipping foldercatshipping"


mvn clean package  &>>$Log_file
VALIDATE $? "clearing the package"

mv target/shipping-1.0.jar shipping.jar &>>$Log_file
VALIDATE $? "moving and rename the jar file" &>>$Log_file


cp $SCRIPT_DIR/shipping.service /etc/systemd/system/shipping.service &>>$Log_file

systemctl daemon-reload &>>$Log_file
VALIDATE $? "daemon services started"

systemctl enable shipping &>>$Log_file
VALIDATE $? "Enabling the shaiipng"

systemctl start shipping &>>$Log_file
VALIDATE $? "starting the shipping"

dnf install mysql -y &>>$Log_file
VALIDATE $? "Installing mysql"

mysql -h mysql.adamshafi.shop -u root -p$MYSQL_ROOT_PASSWORD -e 'use cities'

if [ $? -ne 0 ]
then
mysql -h mysql.adamshafi.shop -uroot -p$MYSQL_ROOT_PASSWORD < /app/db/schema.sql &>>$Log_file
mysql -h mysql.adamshafi.shop -uroot -p$MYSQL_ROOT_PASSWORD < /app/db/app-user.sql &>>$Log_file
mysql -h mysql.adamshafi.shop -uroot -p$MYSQL_ROOT_PASSWORD < /app/db/master-data.sql &>>$Log_file
VALIDATE $? "Loading data into mysql"
else
 echo "Already data loaded..Skipping"
fi
systemctl restart shipping &>>$Log_file
VALIDATE $? "Restarted shipping"


END_TIME=$(date +%s)
TOTAL_TIME=$(( $END_TIME - $START_TIME ))

echo -e "the script running succesfully:$G....Time taken $TOTAL_TIME secounds" | tee -a $Log_file


