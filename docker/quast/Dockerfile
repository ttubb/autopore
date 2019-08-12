#Base image
FROM ubuntu:xenial

#Constants
ARG QUAST_VERSION=5.0.2

#Prerequisites
ENV TZ=Europe/Berlin
ENV LANGUAGE="en_US.UTF-8"
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
 && echo $TZ > /etc/timezone
RUN apt-get update \
 && apt-get install -y wget \
                       zlib1g-dev \
                       pkg-config \
		       libfreetype6-dev \
		       libpng-dev \
		       g++ \
		       make \
		       perl \
		       python \
		       python-matplotlib \
		       python-setuptools \
		       locales \
		       python-pip \
 && locale-gen en_US.UTF-8
ENV LC_ALL=C

#Set workdir
WORKDIR /software

#Install quast
RUN python -m pip install -U pip
ENV LC_ALL=C
RUN wget https://github.com/ablab/quast/releases/download/quast_${QUAST_VERSION}/quast-${QUAST_VERSION}.tar.gz \
 && tar -xzf quast-${QUAST_VERSION}.tar.gz \
 && rm -r quast-${QUAST_VERSION}.tar.gz
WORKDIR /software/quast-${QUAST_VERSION}
RUN ./setup.py install
WORKDIR /software

#Cleanup
RUN apt-get clean
