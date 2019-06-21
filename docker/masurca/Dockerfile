FROM ubuntu:18.04

ARG MASURCA_VERSION=3.3.1

RUN apt-get update \
 && apt-get install -y wget \
                       libboost-all-dev \
		       libbz2-dev
		       
#Install MaSuRCA
WORKDIR /software
RUN wget https://github.com/alekseyzimin/masurca/releases/download/v${MASURCA_VERSION}/MaSuRCA-${MASURCA_VERSION}.tar.gz
RUN tar -xf *.tar.gz \
 && rm *.tar.gz \
 && mv * masurca
WORKDIR /software/masurca
RUN chmod +x install.sh
RUN ./install.sh
RUN chmod +x bin/masurca
ENV PATH="/software/masurca/bin:${PATH}"

RUN apt-get clean
