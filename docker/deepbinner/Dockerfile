#Base Image
FROM python:3.7-slim

#Constants
ARG DEEPBINNER_VERSION=0.2.0-7-g319bae8
ARG TENSORFLOW_VERSION=1.13.1

#Set Workdir
WORKDIR /software

#Prerequisites
RUN apt-get update \
 && apt-get install -y git \
 && apt-get install -y make

#Install Deepbinner
RUN pip3 install tensorflow==${TENSORFLOW_VERSION}
RUN git clone https://github.com/rrwick/Deepbinner.git
WORKDIR /software/Deepbinner
RUN git checkout v${DEEPBINNER_VERSION}
RUN git pull origin pull/30/head
RUN pip3 install .
ENV TERM xterm

#Cleanup
RUN apt-get clean
