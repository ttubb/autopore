#CAREFUL: if compiled on a CPU with AVX-512 support (e.g. intel xeons released after 2016) racon will not run on CPUs lacking AVX-512 support (e.g. AMD epyc-family). The "latest" release of this image is automatically built by dockerhub, so it might require AVX-512 support.

#Base Image
FROM ubuntu:18.04

#Constants
ARG RACON_VERSION=1.4.3

#Prerequistes
RUN apt-get update \
 && apt-get install -y git \
                       gcc \
		       g++ \
		       make \
                       cmake

#Set Workdir
WORKDIR /software

#Install Racon
RUN git clone --recurse-submodules https://github.com/isovic/racon.git racon
WORKDIR /software/racon
RUN git checkout ${RACON_VERSION}
WORKDIR /software/racon/build
RUN cmake -DCMAKE_BUILD_TYPE=Release ..
RUN make
ENV PATH="/software/racon/build/bin:${PATH}"
WORKDIR /data

#Cleanup
RUN apt-get clean
