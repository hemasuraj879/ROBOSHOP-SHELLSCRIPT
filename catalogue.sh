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
    exit 1
else
    echo "ROBOSHOP USER ALREADY EXISTS"
fi 

WORKDIR=$(/app)
if [ -d $WORKDIR ]
then
    ehco "/APP DIRECTORY EXISTS"
else
    echo "/APP DIRECTORY DOES NOT EXISTS"
    mkdir /app &>>$LOGFILE
fi 

curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOGFILE
VALIDATE $? "SETTING UP NODEJS"

yum install nodejs -y  &>>$LOGFILE
VALIDATE $? "INSTALLING  NODEJS"

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip  &>>$LOGFILE
VALIDATE $? "DOWNLOADING THE CONTENT"

cd /app &>>$LOGFILE
VALIDATE $? "MOVING TO THE CONTENT"

npm install &>>$LOGFILE
VALIDATE $? "INSTALLING THE DEPENDENCIES"


