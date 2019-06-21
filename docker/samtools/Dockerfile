#Base images
FROM ubuntu:18.04

#Constants
ARG SAMTOOLS_VERSION=1.7-1

#Install samtools
RUN apt-get update \
 && apt-get install -y samtools=${SAMTOOLS_VERSION}

#Cleanup
RUN apt-get clean
