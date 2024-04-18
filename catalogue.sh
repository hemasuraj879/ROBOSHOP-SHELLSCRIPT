#!/bin//bash

# THIS SCRIPT IS TO GET THE ALERT EMAIL OF DISK USAGE IF IT IS MORE THAN THREESHOLD LIMIT

LOGSDIR=/tmp/shell-script-log
LOGFILE=$LOGSDIR/$0-$DATE.log
SCRIPT_NAME=$0
DATE=$(date +%Y-%m-%d)

USERID=$(id -u)
if [ $USERID -ne 0 ]
then
    echo "ERROR: PLEASE SWITCH TO ROOT USER"
    exit 1
fi

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo "$2 IS FAILURE"
    else
        echo "$2 IS SUCCESS"
    fi 
}

ROBOSHOP_USER=$(id roboshop) &>>$LOGFILE
if [ $ROBOSHOP_USER -ne 0 ]
then
    ehco "ROBOSHOP USER DOES NOT EXISTS"
    useradd roboshop &>>$LOGFILE
else
    echo "ROBOSHOP USER ALREADY EXISTS"
fi 

# mkdir /app &>>$LOGFILE
# VALIDATE $? "CREATING DIRECTORY"

curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOGFILE
VALIDATE $? "SETTING UP NODEJS"

yum install nodejs -y  &>>$LOGFILE
VALIDATE $? "INSTALLING  NODEJS"

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip  &>>$LOGFILE
VALIDATE $? "DOWNLOADING THE CONTENT"

cd /app &>>$LOGFILE
VALIDATE $? "MOVING TO THE CONTENT"

unzip /tmp/catalogue.zip &>>$LOGFILE
VALIDATE $? "UNZIPPING THE APPLICATION"

npm install &>>$LOGFILE
VALIDATE $? "INSTALLING THE DEPENDENCIES"

cp /home/centos/ROBOSHOP-SHELLSCRIPT/catalogue.service /etc/systemd/system/catalogue.service &>>$LOGFILE
VALIDATE $? "COPYING THE APPLICATION"

systemctl daemon-reload &>>$LOGFILE
VALIDATE $? "DAEMON RELOADING"

systemctl enable catalogue &>>$LOGFILE
VALIDATE $? "ENABLING CATALOGUE"

systemctl start catalogue &>>$LOGFILE
VALIDATE $? "STARTING CATALOGUE"

cp /home/centos/ROBOSHOP-SHELLSCRIPT/mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOGFILE
VALIDATE $? "COPYING MONGO.REPO"

yum install mongodb-org-shell -y   &>>$LOGFILE
VALIDATE $? "INSTALLING MONGO.REPO"

mongo --host 172.31.87.35 </app/schema/catalogue.js &>>$LOGFILE
VALIDATE $? "LOADING THE SHCEMA"
