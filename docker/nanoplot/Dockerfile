#Base images
FROM python:3.7-slim

#Constants
ARG NANOPLOT_VERSION=1.22.0

#Preqrequisites
RUN apt-get update && apt-get install -y make \
                                         gcc \
					 libbz2-dev \
					 liblzma-dev \
					 libz-dev

#Setup
RUN pip3 install nanoplot==${NANOPLOT_VERSION}