#Base image
FROM ubuntu:18.04

#Setup
RUN apt-get update \
 && apt-get install -y python3-pip

#Install medaka
RUN pip3 install medaka

#Cleanup
RUN apt-get clean