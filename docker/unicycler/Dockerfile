FROM ubuntu:18.04

ARG UNICYCLER_VERSION=0.4.7
ARG SPADES_VERSION=3.13.0
ARG RACON_VERSION=1.3.3
ARG PILON_VERSION=1.23
ARG BOWTIE2_VERSION=2.3.5.1
ARG SAMTOOLS_VERSION=1.7-1
ARG NCBI_BLASTPLUS_VERSION=2.6.0-1

WORKDIR /software

RUN apt-get update \
 && apt-get install -y python3 \
                       python3-pip \
		       python3-setuptools \
		       git \
		       gcc \
		       g++ \
		       cmake \
		       make \
		       zlib1g-dev \
		       libbz2-dev \
		       liblzma-dev \
		       default-jre \
		       wget \
		       unzip \
# install samtools
		       samtools=${SAMTOOLS_VERSION} \
# install blast+
		       ncbi-blast+=${NCBI_BLASTPLUS_VERSION}

# install unicycler
RUN git clone https://github.com/rrwick/Unicycler.git
WORKDIR /software/Unicycler
RUN git checkout v${UNICYCLER_VERSION}
RUN python3 setup.py install
WORKDIR /software

# install spades
RUN wget https://github.com/ablab/spades/releases/download/v${SPADES_VERSION}/SPAdes-${SPADES_VERSION}-Linux.tar.gz
RUN tar -xzf SPAdes-${SPADES_VERSION}-Linux.tar.gz \
 && rm SPAdes-${SPADES_VERSION}-Linux.tar.gz
ENV PATH="/software/SPAdes-${SPADES_VERSION}-Linux/bin:${PATH}"
RUN chmod +x /software/SPAdes-${SPADES_VERSION}-Linux/bin/spades.py

# install racon
RUN git clone --recurse-submodules https://github.com/isovic/racon.git racon
WORKDIR /software/racon
RUN git checkout ${RACON_VERSION}
WORKDIR /software/racon/build
RUN cmake -DCMAKE_BUILD_TYPE=Release ..
RUN make
ENV PATH="/software/racon/build/bin:${PATH}"
WORKDIR /software

# install pilon
WORKDIR /software/pilon
RUN wget https://github.com/broadinstitute/pilon/releases/download/v${PILON_VERSION}/pilon-${PILON_VERSION}.jar
ENV PATH="/software/pilon:${PATH}"
WORKDIR /software

# install bowtie2
RUN wget https://github.com/BenLangmead/bowtie2/releases/download/v${BOWTIE2_VERSION}/bowtie2-${BOWTIE2_VERSION}-linux-x86_64.zip
RUN unzip bowtie2-*.zip \
 && rm bowtie2-*.zip
ENV PATH="/software/bowtie2-${BOWTIE2_VERSION}-linux-x86_64:${PATH}"
RUN chmod +x /software/bowtie2-${BOWTIE2_VERSION}-linux-x86_64/bowtie2

ENV TERM xterm
RUN apt-get clean
