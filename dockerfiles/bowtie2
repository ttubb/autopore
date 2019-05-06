FROM python:3.7-slim

ARG BOWTIE2_VERSION=2.3.5.1

RUN apt-get update \
 && apt-get install -y wget \
                       unzip \
		       libsys-hostname-long-perl
		       
WORKDIR /software

#Install Bowtie2
RUN wget https://github.com/BenLangmead/bowtie2/releases/download/v${BOWTIE2_VERSION}/bowtie2-${BOWTIE2_VERSION}-linux-x86_64.zip
RUN unzip bowtie2-*.zip \
 && rm bowtie2-*.zip
ENV PATH="/software/bowtie2-${BOWTIE2_VERSION}-linux-x86_64:${PATH}"
RUN chmod +x /software/bowtie2-${BOWTIE2_VERSION}-linux-x86_64/bowtie2

RUN apt-get clean
