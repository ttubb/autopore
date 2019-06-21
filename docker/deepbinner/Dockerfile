FROM python:3.7-slim

ARG DEEPBINNER_VERSION=0.2.0-7-g319bae8
ARG TENSORFLOW_VERSION=1.13.1

WORKDIR /deepbinner

RUN apt-get update \
 && apt-get install -y git \
 && apt-get install -y make

#Install Deepbinner
RUN pip3 install tensorflow==${TENSORFLOW_VERSION}
RUN git clone https://github.com/rrwick/Deepbinner.git
WORKDIR /deepbinner/Deepbinner
RUN git checkout v${DEEPBINNER_VERSION}
RUN pip3 install .

ENV TERM xterm
RUN apt-get clean
