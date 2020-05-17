#!/bin/bash

defaultBuildId=devops-import-server-1.0-SNAPSHOT.war

buildId=${1:-$defaultBuildId}

# Install software application
echo "Installing software application"
cd /tmp
pwd
ls -l
echo "This is the COPY COMMAND:";
echo "cp \"$buildId\" /var/lib/tomcat8/webapps/"
cp "$buildId" /var/lib/tomcat8/webapps/

echo "Verifying build is copy to webapps";
cd /var/lib/tomcat8/webapps/
pwd
ls -l

echo "This is the build Id:";
echo $buildId;

echo "Removing war extension from build id"
echo "This is the Application name:";
appName="${buildId%.*}"

echo "Wait for 2 minutes for tomcat to deploy app";
sleep 3m 

appUrl="http://localhost:8080/$appName"

echo "This is the APP URL:";
echo $appUrl;

curl $appUrl;
sleep 30s 
echo "Done deploying application";
