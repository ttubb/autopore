FROM ubuntu:18.04

ARG PILON_VERSION=1.23

WORKDIR /software

RUN apt-get update \
 && apt-get install -y default-jre \
                       wget

RUN wget https://github.com/broadinstitute/pilon/releases/download/v${PILON_VERSION}/pilon-${PILON_VERSION}.jar
RUN mv pilon-${PILON_VERSION}.jar pilon.jar
RUN chmod 744 pilon.jar

RUN apt-get clean
