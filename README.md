# docker-connextcms
A Dockerfile used to createa Docker Image for running ConnextCMS and KeystoneJS in a Docker Container

This repository contains two Dockerfiles. The one in this root directory will create a Docker image
with a functional version of ConnextCMS and KeystoneJS. It depends on the official `mongo` Docker image.
Instructions for running the image are in the top of the Dockerfile.

A second Dockerfile eists in the `buildFromSource` directory. This creates an environment ready to run
the `yo keystone` command to build KeystoneJS from scratch. This environment is used to create and update
the [keystone4-compiled](https://github.com/christroutner/keystone4-compiled) repository used by first 
Dockerfile.

The Dockerfiles assume that the MongoDB continer has it's internal port 27017 maps to host port 3500.

