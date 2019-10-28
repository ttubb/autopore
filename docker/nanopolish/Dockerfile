#Base images
FROM ubuntu:18.04

#Constants
ARG NANOPOLISH_VERSION=0.11.2

#Setup
RUN apt-get update \
&& apt-get install -y git \
                      make \
                      wget \
                      build-essential \
                      libz-dev \
                      python3 \
                      python3-all-dev \
                      python3-pip \
                      libbz2-dev \
                      liblzma-dev \
                      libffi-dev \
                      libncurses5-dev \
                      libcurl4-gnutls-dev \
                      libssl-dev

RUN pip3 install biopython
RUN pip3 install Cython
RUN pip3 install pysam

#Set Workdir
WORKDIR /software

#Install nanopolish
RUN git clone --recursive https://github.com/jts/nanopolish.git
WORKDIR /software/nanopolish
RUN git checkout v${NANOPOLISH_VERSION}
RUN make
ENV PATH="/software/nanopolish:${PATH}"
ENV PATH="/software/nanopolish/scripts:${PATH}"
RUN chmod +x /software/nanopolish/nanopolish
RUN chmod +x /software/nanopolish/scripts/nanopolish_makerange.py

#Cleanup
RUN apt-get clean
