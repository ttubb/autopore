#Base image
FROM python:3.7-slim

#Constants
ARG ONT_FAST5_API_VERSION=1.3.0

#Set workdir
WORKDIR /software

#Install ont-fast5-api
RUN pip3 install ont-fast5-api==${ONT_FAST5_API_VERSION}
