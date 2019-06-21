#Base images
FROM ubuntu:18.04

#Constants
ARG MINIASM_VERSION=0.3

#Set Workdir
WORKDIR /software

#Setup
RUN apt-get update \
 && apt-get install -y make \
                       gcc \
                       zlib1g-dev \
                       curl

#Install racon
WORKDIR /software
RUN curl -L -o miniasm.tar.gz https://github.com/lh3/miniasm/archive/v${MINIASM_VERSION}.tar.gz
RUN tar -xf miniasm.tar.gz
WORKDIR /software/miniasm-${MINIASM_VERSION}
RUN make
ENV PATH="/software/miniasm-${MINIASM_VERSION}:$PATH"

#Cleanup
RUN apt-get clean
