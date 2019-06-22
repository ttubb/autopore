#Base images
FROM ubuntu:18.04

#Constants
ARG RACON_VERSION=1.3.3

#Setup
RUN apt-get update \
 && apt-get install -y gcc\
                       g++ \
                       cmake \
                       make \
                       git

#Set Workdir
WORKDIR /software

#Install racon
RUN git clone --recurse-submodules https://github.com/isovic/racon.git racon
WORKDIR /software/racon
RUN git checkout ${RACON_VERSION}
WORKDIR /software/racon/build
RUN cmake -DCMAKE_BUILD_TYPE=RELEASE ..
RUN make
ENV PATH="/software/racon/build/bin:${PATH}"

#Cleanup
RUN apt-get clean
