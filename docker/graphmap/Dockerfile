#Base images
FROM ubuntu:16.04

#Constants
#ARG GRAPHMAP_VERSION=latest
#Ubuntu intsallation of any specified graphmap release is currently not possible because of bugs in graphmaps makefile.
#For this reasen, whatever version is acquired through git clone will be installed.

#Setup
RUN apt-get update \
 && apt-get -y install make \
                       build-essential \
                       libz-dev \
                       git

#Set Workdir
WORKDIR /software

#Install graphmap
RUN git clone https://github.com/isovic/graphmap.git
WORKDIR /software/graphmap
RUN make modules
RUN make rebuild
ENV PATH="/software/graphmap/bin/Linux-x64:${PATH}"
RUN chmod +x /software/graphmap/bin/Linux-x64/graphmap

#Cleanup
RUN apt-get clean
