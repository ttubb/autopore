FROM mcr.microsoft.com/java/jre:11u2-zulu-ubuntu

ARG CANU_VERSION=1.8
      
RUN apt-get update \
 && apt-get -y install build-essential \
                       wget \
                       gnuplot

WORKDIR /software
      
RUN wget https://github.com/marbl/canu/archive/v${CANU_VERSION}.tar.gz
RUN tar -xzf v${CANU_VERSION}.tar.gz && rm v${CANU_VERSION}.tar.gz
WORKDIR /software/canu-${CANU_VERSION}/src
RUN make
ENV PATH="/software/canu-${CANU_VERSION}/Linux-amd64/bin:${PATH}"
RUN apt-get clean
