#Base Image
FROM ubuntu:18.04

#Constants
ARG MEDAKA_VERSION=0.8.2
ARG MINIMAP2_VERSION=2.16
ARG SAMTOOLS_VERSION=1.9
ARG HTSLIB_VERSION=1.3.2

#Set Workdir
WORKDIR /software

#Prerequisites
RUN apt-get update \
 && apt-get install -y git \
                       bzip2 \
                       gcc \
		       zlib1g-dev \
		       libbz2-dev \
		       liblzma-dev \
		       libffi-dev \
		       libncurses5-dev \
		       libcurl4-gnutls-dev \
		       libssl-dev \
		       curl \
		       make \
		       wget \
		       python3-all-dev \
		       python-virtualenv \
		       virtualenv

#Install medaka
RUN wget https://github.com/nanoporetech/medaka/archive/v${MEDAKA_VERSION}.tar.gz
RUN tar xf v${MEDAKA_VERSION}.tar.gz
RUN rm v${MEDAKA_VERSION}.tar.gz
WORKDIR /software/medaka-${MEDAKA_VERSION}
RUN make install
WORKDIR /software
ENV PATH="/software/medaka-${MEDAKA_VERSION}/venv/bin:$PATH"

#Cleanup
RUN apt-get clean
