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

   VALIDATE(){
    if [ $1 -eq 0 ]
    then
    echo -e "$2 is....$G success $N" | tee -a $Log_file
     else 
     echo -e "$2 is.....$R failure $N"| tee -a $Log_file
     exit 1
     fi
   }



dnf module disable nodejs -y
VALIDATE $? "Disbling mongodb"

dnf module enable nodejs:20 -y
VALIDATE $? "enabled nodejs:20"


dnf install nodejs -y
VALIDATE $? "Installing nodejs"

id roboshop

  if [ $? -ne 0 ]
   then
        useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
        VALIDATE $? "systemuser cerated"
  else
     echo "roboshop user already created....$Y skipping"
     fi


mkdir -p /app 
VALIDATE $? "Directory cerated"

curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip 
VALIDATE $? "downloading catalouge data"

cd /app 

unzip /tmp/catalogue.zip
VALIDATE $? "unzipping foldercatalouge"

npm install
VALIDATE $? "Installing dependency"

cp $SCRIPT_DIR/catalogue.service /etc/systemd/system/catalogue.service
VALIDATE $? "copying catalogue services"

systemctl daemon-reload
VALIDATE $? "deamon-reload"

systemctl enable catalogue 
VALIDATE $? "enableing catalogue"

systemctl start catalogue
VALIDATE $? "started catataloge"

cp $SCRIPT_DIR/mongo.repo   /etc/yum.repos.d/mongo.repo

dnf install mongodb-mongosh -y
VALIDATE $? "Installing momgodb client"

mongosh --host mongodb.adamshafi.shop </app/db/master-data.js
VALIDATE $? "Loading data into mongodb"











