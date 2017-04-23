#Creates a ConnextCMS/KeystoneJS installation in Ubuntu container with user/password connextcms/password

#Build docker image as 'keystonejs':
#docker build -t connextcms .

#Execute my keystonejs docker image
#docker container run --name connextcms --rm -it connextcms bash

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

#Copy the source files into the container working directory.
COPY mongodb.service /home/connextcms

#VOLUME /home/connextcms

#Install mongodb
#RUN apt-get install -y dirmngr
#RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
#RUN echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list
#RUN apt-get update
#RUN apt-get install -y mongodb-org


#Log into the shell as the newly created user
#USER connextcms

