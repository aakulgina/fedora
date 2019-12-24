#!/bin/bash
docker pull jenkins
export CONFIG_FOLDER=/opt/jenkins/config
mkdir $CONFIG_FOLDER
chown 1000 $CONFIG_FOLDER
docker start --restart=always -p 49001:8080 \ -p 8080:8080 \
-p 50000:50000 \
-v $CONFIG_FOLDER:/var/jenkins_home:z \
--name jenkins -t jenkins