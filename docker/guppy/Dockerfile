#Base image
FROM ubuntu:16.04

#Constants
ARG GUPPY_VERSION=3.1.3

#Set workdir
WORKDIR /software

#Prerequisites
RUN apt-get update \
 && apt-get install -y wget \
                       apt-transport-https \
		       libzmq5 \
		       libcurl4-openssl-dev \
		       libssl-dev \
		       libhdf5-cpp-11 \
		       libboost-atomic1.58.0 \
		       libboost-chrono1.58.0 \
		       libboost-date-time1.58.0 \
		       libboost-filesystem1.58.0 \
		       libboost.program-options1.58.0 \
		       libboost-regex1.58.0 \
		       libboost.system1.58.0 \
		       libboost-log1.58.0

#Install guppy
RUN wget -q https://mirror.oxfordnanoportal.com/software/analysis/ont_guppy_cpu_${GUPPY_VERSION}-1~xenial_amd64.deb \
 && dpkg -i *.deb \
 && rm *.deb

#Cleanup
RUN apt-get clean
