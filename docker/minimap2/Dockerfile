#Base images
FROM ubuntu:18.04

#Constants
ARG MINIMAP2_VERSION=2.16

#Setup
RUN apt-get update \
 && apt-get install -y curl
 
#Set Workdir
WORKDIR /software

#Install minimap2
RUN curl -L -o minimap.tar.bz2 https://github.com/lh3/minimap2/releases/download/v${MINIMAP2_VERSION}/minimap2-${MINIMAP2_VERSION}_x64-linux.tar.bz2
RUN tar -jxvf minimap.tar.bz2 \
 && rm minimap.tar.bz2
ENV PATH="/software/minimap2-${MINIMAP2_VERSION}_x64-linux:${PATH}"

#Cleanup
RUN apt-get clean
