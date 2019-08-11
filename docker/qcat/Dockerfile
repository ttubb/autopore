#Base image
FROM python:3.7-slim

#Constants
ARG QCAT_VERSION=1.1.0

#Set Workdir
WORKDIR software

#Preqrequisites
RUN apt-get update \
 && apt-get install -y build-essential \
                       python3-pkg-resources \
RUN pip3 install --upgrade \
                 setuptools \
                 wheel

#Install qcat
RUN pip3 install==${QCAT_VERSION}

#Cleanup
RUN apt-get clean
