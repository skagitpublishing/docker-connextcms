#Creates a ConnextCMS/KeystoneJS installation in Ubuntu container with user/password connextcms/password
#This version of the Dockerfile leverages a pre-built git hub repository that is faster and lighter
#weight than building KeystoneJS from source.

#INSTRUCTIONS
#Build docker image as 'keystonejs':
#docker build -t connextcms .

#Run the MongoDB image
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

#Install KeystoneJS Dependencies
RUN apt-get install -y git
RUN apt-get install curl
#RUN apt-get install -y make
#RUN apt-get install -y g++
#RUN apt-get install -y python

#Install Node and NPM
RUN curl -sL https://deb.nodesource.com/setup_4.x -o nodesource_setup.sh
RUN bash nodesource_setup.sh
RUN apt-get install -y nodejs
RUN apt-get install -y build-essential
RUN npm install -g npm




#VOLUME /home/connextcms

#Log into the shell as the newly created user
USER connextcms

RUN git clone https://github.com/christroutner/keystone4-compiled
RUN git clone https://github.com/skagitpublishing/ConnextCMS
