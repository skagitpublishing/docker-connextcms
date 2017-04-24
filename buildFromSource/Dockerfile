#Creates a ConnextCMS/KeystoneJS installation in Ubuntu container with user/password connextcms/password
#This version of the Dockerfile builds a Docker Image with an environment capable of building
#KeystoneJS from source using 'yo keystone'.

#INSTRUCTIONS
#Build docker image as 'keystonejs':
#docker build -t connextcms .

#Run the MongoDB image
#docker run --name mongo -d mongo
#Map port 27017 on the image to 3500 on the host.
#docker run --name mongo -d -p 3500:27017 mongo

#Execute my keystonejs docker image
#docker container run --name connextcms --rm -it connextcms bash
#docker container run --name connextcms --link mongo:mongo --rm -it connextcms bash

#IMAGE BUILD COMMANDS
FROM ubuntu:16.10
MAINTAINER Chris Troutner <chris.troutner@gmail.com>

#Update the OS and install any OS packages needed.
RUN apt-get update
RUN apt-get install -y sudo

#Create the user 'connextcms' and add them to the sudo group.
RUN useradd -ms /bin/bash connextcms
RUN adduser connextcms sudo

#Set password to 'password' change value below if you want a different password
RUN echo connextcms:password | chpasswd

#Set the working directory to be the connextcms home directory
WORKDIR /home/connextcms

#Install mongodb
#RUN apt-get install -y dirmngr
#RUN apt-get install -y systemd
#RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
#RUN echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list
#RUN apt-get update
#RUN apt-get install -y mongodb-org
#COPY mongodb.service /etc/systemd/system/
#RUN systemctl start mongodb
#RUN systemctl enable mongodb

#Install KeystoneJS Dependencies
RUN apt-get install -y make
RUN apt-get install -y git
RUN apt-get install -y g++
RUN apt-get install -y curl
RUN apt-get install -y python
RUN apt-get install -y nano

#Install Node and NPM
RUN curl -sL https://deb.nodesource.com/setup_4.x -o nodesource_setup.sh
RUN bash nodesource_setup.sh
RUN apt-get install -y nodejs
RUN apt-get install -y build-essential
RUN npm install -g npm




#VOLUME /home/connextcms

#Log into the shell as the newly created user
#USER connextcms

#RUN echo 'password' | sudo -S command
#RUN sudo npm install -g yo
#RUN sudo npm install -g generator-keystone

#Installation steps:
# 1. run 'yo keystone' to build a KeystoneJS app using the yeoman generator
# 2. change the permission of the .config file by running this command:
#  sudo chown -R connextcms .config
# 3. Add a line to the keystone.js file at the bottom of keystone.init() to instruct 
#    KeystoneJS to connect to MongoDB running in a separate Container:
#    'mongo': 'mongodb://172.17.0.1:3500/test'