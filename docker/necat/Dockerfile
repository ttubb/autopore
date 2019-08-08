#Base image
FROM perl:5.28.1

#Constants
ARG NECAT_VERSION=0.01
ARG NECAT_FILENAME=necat_20190307_linux_amd64.tar.gz
ARG AUTOPORE_SCRIPT_PATH=https://raw.githubusercontent.com/ttubb/autopore/master/scripts/
ARG AUTOPORE_SCRIPT1=necat_cfgcreator.sh
ARG AUTOPORE_SCRIPT2=necat_readlister.sh

#Set workdir
WORKDIR /necat

#Prerequisites
RUN apt-get update \
       && apt-get install -y wget

#Install necat and download scripts
RUN wget https://github.com/xiaochuanle/NECAT/releases/download/v${NECAT_VERSION}/${NECAT_FILENAME} \
       && tar xzvf ${NECAT_FILENAME} \
       && rm ${NECAT_FILENAME}
RUN wget ${AUTOPORE_SCRIPT_PATH}${AUTOPORE_SCRIPT1}
RUN wget ${AUTOPORE_SCRIPT_PATH}${AUTOPORE_SCRIPT2}
ENV PATH="/necat/NECAT/Linux-amd64/bin:${PATH}"
ENV PATH="/necat:${PATH}"
RUN chmod +x /necat/${AUTOPORE_SCRIPT1}
RUN chmod +x /necat/${AUTOPORE_SCRIPT2}

#Cleanup
RUN apt-get clean
