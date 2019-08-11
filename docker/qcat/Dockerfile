#Base image
FROM ubuntu:18.04

#Constants
ARG QCAT_VERSION=1.1.0

#Set Workdir
WORKDIR software

#Preqrequisites
RUN apt-get update \
 && apt-get install -y build-essential \
                       python3-pkg-resources \
		       python3.7 \
		       python3-pip
RUN pip3 install --upgrade \
                 setuptools \
                 wheel

#Install qcat
RUN pip3 install qcat==${QCAT_VERSION}

#Cleanup
RUN apt-get clean
