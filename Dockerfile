#Creates a ConnextCMS/KeystoneJS installation in Ubuntu container with user/password: connextcms/password
#This version of the Dockerfile leverages a pre-built git hub repository that is faster and lighter
#weight than building KeystoneJS from source.

#INSTRUCTIONS
#Build and launch ConnextCMS by executing the docker-compose file with the following command:
#docker-compose up -d


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
RUN apt-get update
RUN apt-get install -y git
RUN apt-get install -y curl
RUN apt-get install -y nano
#RUN apt-get install -y make
#RUN apt-get install -y g++
RUN apt-get install -y python

#Fixes kerberos issue
RUN apt-get install -y libkrb5-dev

#Install Node and NPM
RUN curl -sL https://deb.nodesource.com/setup_4.x -o nodesource_setup.sh
RUN bash nodesource_setup.sh
RUN apt-get install -y nodejs
RUN apt-get install -y build-essential
#RUN npm install -g npm

#Give node.js permission to run on port 80
RUN apt-get install -y libcap2-bin
RUN setcap cap_net_bind_service=+ep /usr/bin/nodejs

#Create a volume for persisting MongoDB data.
VOLUME /data/db

#Create a directory for customizing the new site.
VOLUME /home/connextcms/theme
VOLUME /home/connextcms/plugins
VOLUME /home/connextcms/public

#Change ownership of directories
#RUN usermod -u 1000 /home/connextcms/public
#RUN usermod -u 1000 /home/connextcms/theme
#RUN usermod -u 1000 /home/connextcms/plugins

#Log into the shell as the newly created user
USER connextcms

#Clone the keystone files.
RUN git clone https://github.com/skagitpublishing/keystone4-compiled
RUN mv keystone4-compiled keystone4

#Clone ConnextCMS
RUN git clone https://github.com/skagitpublishing/ConnextCMS
RUN mv ConnextCMS connextCMS

#Clone plugins
#RUN git clone https://github.com/skagitpublishing/plugin-template-connextcms

COPY finalsetup finalsetup
COPY keystone.js keystone.js
COPY mergeandlaunch mergeandlaunch
COPY dummyapp.js dummyapp.js
RUN echo 'password' | sudo -S pwd
RUN sudo chmod 775 finalsetup
RUN sudo chmod 775 mergeandlaunch
RUN ./finalsetup

#Installation is buggy.
#RUN sudo npm install -g node-inspector

#Change ownership of directories
#Does not work
#RUN sudo chown -R connextcms /home/connextcms/public
#RUN sudo chown -R connextcms /home/connextcms/theme
#RUN sudo chown -R connextcms /home/connextcms/plugins

#Clean up files
#RUN rm -f finalsetup /theme/
#RUN rm -f keystone.js
#RUN rm -f nodesource_setup.sh

#Use port 80 if you don't plan to use nginx and have only one installation.
#EXPOSE 80

#Use port 3000 or above if you plan to use nginx as a proxy and/or have multiple installations on the same server.
EXPOSE 3000

#Temp commands just to get the container running with docker-compose.
#You can then enter the container with command: docker exec -it <container ID> /bin/bash
#WORKDIR /home/connextcms/myCMS
#CMD ["node", "dummyapp.js"]

#change directory where the mergeandlaunch script is located.
WORKDIR /home/connextcms
#Run the mergeandlaunch script before starting Keystone with node.
ENTRYPOINT ["./mergeandlaunch", "node", "keystone.js"]



