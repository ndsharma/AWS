#!/usr/bin/env bash
# debug
#set -x

echo "## Check if S3 bucket exists else create it and copy the jar file."
CODE_BUCKET="titan-ums-dev"
BUCKET_NAME=`aws s3 ls |egrep "$CODE_BUCKET$" |awk '{print$3}'`
if [ ! "$BUCKET_NAME" == "$CODE_BUCKET" ]; then
  echo "## Start to create S3 code bucket: s3://$CODE_BUCKET"
  aws s3api create-bucket --bucket $CODE_BUCKET --region us-west-2 --create-bucket-configuration LocationConstraint=us-west-2 --acl private
  if [ $? -ne 0 ]; then
    echo "## Could not create bucket $CODE_BUCKET"
    exit 1
  fi
else
  echo "## S3 bucket $CODE_BUCKET already exists"
fi

echo "## Start to copy files from local to S3 code bucket"
JAR_FILE="titan-ums-assembly-0.1-SNAPSHOT.jar"
cd /home/teamcity/BuildAgent/work/323a031d52d81f92/target/scala-2.11/
# copy spark jar file
if [ -f $JAR_FILE ]; then
  aws s3 cp $JAR_FILE s3://$CODE_BUCKET/setup/$JAR_FILE
  if [ $? -ne 0 ]; then
    echo "## Failed to copy $JAR_FILE to s3://$CODE_BUCKET/setup/"
    exit 1
  fi
else
  echo "## Spark job jar file $JAR_FILE is missing."
  exit 1
fi
