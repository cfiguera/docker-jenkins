FROM ubuntu:trusty

MAINTAINER Carles Figuera <cfiguera@referup.com>

ENV JENKINS_VERSION 1.642.2
ENV JENKINS_HOME /home/jenkins
VOLUME $JENKINS_HOME

ENV TZ "Europe/Madrid"
RUN echo $TZ > /etc/timezone

ENV LANG es_ES.UTF-8
RUN locale-gen $LANG
ENV LANG $LANG
ENV LANGUAGE $LANG
ENV LC_ALL $LANG

RUN apt-get update && apt-get install -y moreutils curl wget gdebi git openssh-client openjdk-7-jre-headless && \
    wget http://download.gna.org/wkhtmltopdf/0.12/0.12.2.1/wkhtmltox-0.12.2.1_linux-trusty-amd64.deb && \
    gdebi --n wkhtmltox-0.12.2.1_linux-trusty-amd64.deb

ADD files/settings.xml /opt/settings.xml
ADD http://mirrors.jenkins-ci.org/war-stable/$JENKINS_VERSION/jenkins.war /opt/jenkins.war
RUN chmod 644 /opt/jenkins.war

RUN apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENTRYPOINT ["java", "-jar", "/opt/jenkins.war", "--httpPort=8080", "--httpsPort=8443", "--prefix=/jenkins"]

EXPOSE 8443  
