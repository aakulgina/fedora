#!/usr/bin/bash
docker pull jenkins
export CONFIG_FOLDER=/opt/jenkins/config
mkdir -p $CONFIG_FOLDER
chown 744 $CONFIG_FOLDER
docker run -d --restart always -p 49001:8080 -p 8080:8080 -p 50000:50000 -v /opt/jenkins/config:/var/jenkins_home --name jenkins -t jenkins
sudo systemctl disable jenkins.service
