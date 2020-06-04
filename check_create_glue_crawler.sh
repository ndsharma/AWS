#!/usr/bin/env bash
# debug
#set -x

echo "## Check if AWS Glue Domain Crawlers exists else create them and then configure the S3 target."
Crawler1_Name="dummy_domain_dev"
Existing_Crawler=`aws glue list-crawlers --max-results 100 | egrep "$Crawler1_Name$" | awk '{print$2}'`
if [ ! "$Existing_Crawler" == "$Crawler1_Name" ]; then
  echo "## Start to create Glue Domain Crawler"
  aws glue create-crawler --name "dummy_domain_dev" --database-name "ums" --role "service-role/AWSGlueServiceRole-DefaultRole" --targets "{ \"S3Targets\": [ { \"Path\": \"s3://titan-ums-dev/preagg/domain\" } ] }"
  if [ $? -ne 0 ]; then
    echo "## Could not create Glue Crawler $Crawler1_Name"
    exit 1
  fi
else
  echo "## AWS Glue Crawler $Crawler1_Name already exists"
fi

echo "## Check if AWS Glue File Crawlers exists else create them and then configure the S3 target."
Crawler2_Name="dummy_file_dev"
Existing_Crawler=`aws glue list-crawlers --max-results 100 | egrep "$Crawler2_Name$" | awk '{print$2}'`
if [ ! "$Existing_Crawler" == "$Crawler2_Name" ]; then
  echo "## Start to create Glue Domain Crawler"
  aws glue create-crawler --name "dummy_file_dev" --database-name "ums" --role "service-role/AWSGlueServiceRole-DefaultRole" --targets "{ \"S3Targets\": [ { \"Path\": \"s3://titan-ums-dev/preagg/file\" } ] }"
  if [ $? -ne 0 ]; then
    echo "## Could not create Glue Crawler $Crawler2_Name"
    exit 1
  fi
else
  echo "## AWS Glue Crawler $Crawler2_Name already exists"
fi

echo "## Check if AWS Glue IP Crawlers exists else create them and then configure the S3 target."
Crawler3_Name="dummy_ip_dev"
Existing_Crawler=`aws glue list-crawlers --max-results 100 | egrep "$Crawler3_Name$" | awk '{print$2}'`
if [ ! "$Existing_Crawler" == "$Crawler3_Name" ]; then
  echo "## Start to create Glue Domain Crawler"
  aws glue create-crawler --name "dummy_ip_dev" --database-name "ums" --role "service-role/AWSGlueServiceRole-DefaultRole" --targets "{ \"S3Targets\": [ { \"Path\": \"s3://titan-ums-dev/preagg/ip\" } ] }"
  if [ $? -ne 0 ]; then
    echo "## Could not create Glue Crawler $Crawler3_Name"
    exit 1
  fi
else
  echo "## AWS Glue Crawler $Crawler3_Name already exists"
fi

Crawler1_State=$`aws glue get-crawler --name $Crawler1_Name | egrep service-role | awk '{print $8}'`
if [ ! "$Crawler1_State" == "RUNNING" ]; then
  echo "## Starting $Crawler1_Name"
  aws glue start-crawler --name $Crawler1_Name
  echo `aws glue get-crawler --name $Crawler1_Name | egrep service-role | awk '{print $8}'`
fi

Crawler2_State=$`aws glue get-crawler --name $Crawler2_Name | egrep service-role | awk '{print $8}'`
if [ ! "$Crawler2_State" == "RUNNING" ]; then
  echo "## Starting $Crawler2_Name"
  aws glue start-crawler --name $Crawler2_Name
  echo `aws glue get-crawler --name $Crawler2_Name | egrep service-role | awk '{print $8}'`
fi

Crawler3_State=$`aws glue get-crawler --name $Crawler3_Name | egrep service-role | awk '{print $8}'`
if [ ! "$Crawler3_State" == "RUNNING" ]; then
  echo "## Starting $Crawler3_Name"
  aws glue start-crawler --name $Crawler3_Name
  echo `aws glue get-crawler --name $Crawler3_Name | egrep service-role | awk '{print $8}'`
fi
