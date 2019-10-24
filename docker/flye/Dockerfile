#Base Image
FROM python:3.7-slim

#Constants
ARG FYLE_VERSION=2.6

#Install required packages
RUN apt-get update \
 && apt-get install -y git \
                       g++ \
		       make \
		       zlib1g-dev

#Install flye
WORKDIR /software
RUN git clone https://github.com/fenderglass/Flye
WORKDIR /software/Flye
RUN git checkout ${FLYE_VERSION}
RUN python3 setup.py install
WORKDIR /workdir

#Cleanup
RUN apt-get clean