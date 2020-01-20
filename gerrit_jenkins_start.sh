#!/usr/bin/bash
docker run -d --restart always -ti -p 8080:8080 -p 29418:29418 gerritcodereview/gerrit
docker pull jenkins
mkdir -p /opt/jenkins/config
chown 744 /opt/jenkins/config
docker run -d --restart always -p 49001:8080 -p 8090:8080 -p 50000:50000 -v /opt/jenkins/config:/var/jenkins_home --name jenkins -t jenkins
