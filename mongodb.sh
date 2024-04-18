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


cp /home/centos//ROBOSHOP-SHELLSCRIPT/mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOGFILE
VALIDATE $? "COPYING MONGO.REPO"

yum install mongodb-org -y  &>>$LOGFILE
VALIDATE $? "INSTALLING MONGO.REPO"

systemctl enable mongod &>>$LOGFILE
VALIDATE $? "ENABLING MONGO.REPO"

systemctl start mongod &>>$LOGFILE
VALIDATE $? "STARTING MONGO.REPO"

sed -i 's/127.0.0.1/0.0.0.0 /' /etc/mongod.conf &>>$LOGFILE
VALIDATE $? "EDITING MONGO.CONF"

systemctl restart mongod  &>>$LOGFILE
VALIDATE $? "RESTARING MONGODB"
