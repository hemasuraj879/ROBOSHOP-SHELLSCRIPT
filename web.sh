#!/bin/bash

LOGSDIR=/tmp
LOGSFILE=$LOGSDIR/$0-$DATE.log
SCRIPT_NAME=$0
DATE=$(date +%Y-%m-%d)

USERID=$(id -u)
if [ $? -ne 0 ]
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

yum install nginx -y &>>$LOGSFILE
VALIDATE $? "INSTALLING NGINX"


systemctl enable nginx &>>$LOGSFILE
VALIDATE $? "ENABLING NGINX"

systemctl start nginx &>>$LOGSFILE
VALIDATE $? "STARTING NGINX"

rm -rf /usr/share/nginx/html/* &>>$LOGSFILE
VALIDATE $? "REMOVING THE CONENT"

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip   &>>$LOGSFILE
VALIDATE $? "DOWNLOADING THE CONENT"

cd /usr/share/nginx/html  &>>$LOGSFILE
VALIDATE $? "GOING TO THE APPLICATION FOLDER"

unzip /tmp/web.zip  &>>$LOGSFILE
VALIDATE $? "UNZIPPING THE APPLICATION"

CP /home/centos/ROBOSHOP-SHELLSCRIPT/roboshop.conf /etc/nginx/default.d/roboshop.conf &>>$LOGSFILE
VALIDATE $? "COPYING THE CONF FILE"