#Base image
FROM perl:5.28.1

#Constants
ARG LENGTH_SCRIPT_URL=https://raw.githubusercontent.com/gringer/bioinfscripts/master/fastx-length.pl
ARG FETCH_SCRIPT_URL=https://raw.githubusercontent.com/gringer/bioinfscripts/master/fastx-fetch.pl

#Set workdir
WORKDIR /software

#Prerequisites
RUN apt-get update \
 && apt-get install -y wget

#Download scripts
RUN wget ${LENGTH_SCRIPT_URL}
RUN wget ${FETCH_SCRIPT_URL}

#Cleanup
RUN apt-get clean
