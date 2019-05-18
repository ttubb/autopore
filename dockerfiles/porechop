#Base images
FROM python:3.7-slim

#Constants
ARG PORECHOP_VERSION=0.2.4

#Setup
RUN apt-get update \
 && apt-get -y install git \
                       make \
                       build-essential
 
#Set Workdir
WORKDIR /software

#Install porechop
RUN git clone https://github.com/rrwick/Porechop.git
WORKDIR /software/Porechop
RUN git checkout v${PORECHOP_VERSION}
RUN python3 setup.py install
RUN rm -rf /software/Porechop

#Cleanup
RUN apt-get clean
