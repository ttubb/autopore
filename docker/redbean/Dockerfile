#Base Image
FROM ubuntu:18.04

#Constants
ARG REDBEAN_VERSION=2.5

#Install required packages
RUN apt-get update \
 && apt-get install -y git \
                       make \
		       wget \
		       gcc \
		       zlib1g-dev

#Install redbean/wtdbg2
WORKDIR /software
RUN wget https://github.com/ruanjue/wtdbg2/archive/v${REDBEAN_VERSION}.tar.gz
RUN mkdir redbean \
 && tar -xf v${REDBEAN_VERSION}.tar.gz \
        -C redbean \
	--strip-components 1 \
 && rm v${REDBEAN_VERSION}.tar.gz
WORKDIR /software/redbean
RUN make
ENV PATH="/software/redbean/:${PATH}"

#Cleanup
RUN apt-get clean