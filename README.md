# autopore
A suite of Common Workflow Language tool wrappers and workflows for processing nanopore sequencing data. Each CWL document contains a description which explains its function.
## General
The CWL documents in this repository are supposed to automate the de novo assembly of bacterial genomes. However, most of the wrappers are quite flexible and can be used for other tasks. Running these workflows requires a cwl-runner like (https://github.com/common-workflow-language/cwltool "cwltool").
## Containers
Docker, Singularity or similar software is necessary to execute the tools in the docker containers that are assigned in each tool wrapper. If the execution environment does not support docker containers, tools have to be available locally. Every CWL document references a specific release of a Docker image from this directory. Images are available at https://hub.docker.com/u/ttubb. Please consult the Dockerfile to find out which software versions are used in an image.
## Installation
No installation is needed. Simply dowlnoad (https://github.com/ttubb/autopore/releases "release") or clone the repository using the following command: 'git clone https://github.com/ttubb/autopore.git'
Relative paths of the repository have to be preserved, otherwise workflows will not find the individual tools.
