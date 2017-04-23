#Creates a ConnextCMS/KeystoneJS installation in Ubuntu container with user/password connextcms/password

#Build docker image as 'keystonejs':
#docker build -t keystonejs .

#Execute my keystonejs docker image
#docker container run --name keystonejs --rm -it keystonejs bash

FROM ubuntu:16.10
MAINTAINER Chris Troutner <chris.troutner@gmail.com>

#Update the installation and install any OS packages needed.
RUN apt-get update
RUN apt-get install -y sudo

#Create the user 'connextcms' and add them to the sudo group.
RUN useradd -ms /bin/bash connextcms
RUN adduser connextcms sudo
#Set password to 'password' change value below if you want a different password
RUN echo connextcms:password | chpasswd

#Log into the shell as the newly created user
USER connextcms
WORKDIR /home/connextcms
