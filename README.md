# autopore
This repository contains a suite of Common Workflow Language tool wrappers and workflows for processing nanopore sequencing data. Tools and workflows are aimed at the *de novo* assembly of bacterial genomes, but can also be used for other purposes. Each CWL document contains a description which explains its function. Running tool wrappers or workflows requires a cwl-runner like [cwltool](https://github.com/common-workflow-language/cwltool).
# Tools
CWL documents are available for different tasks associated with *de novo* genome assembly. This is a short introduction to some of the tools/workflows available in the repository.
### Basecalling
**guppyBasecallingWorkflow.cwl:** basecalls regular (1D) reads and creates a single .fastq file containing all reads.

**guppy1d2BasecallingWorkflow.cwl:** is intended for processing reads created in a 1D² experiment. The workflow produces three fastq files: 1D reads, 1D² reads and a file containing both.
### Demultiplexing
**qcatWorkflow:** Uses ONT's [qcat](https://github.com/nanoporetech/qcat) to demultiplex barcoded reads after basecalling.

**deepbinnerWorkflow:** Uses [Deepbinner](https://github.com/rrwick/Deepbinner) to demultiplex basecalled reads after analyzing their raw counterparts (a.k.a. squiggles).
### Assembly
**canuTool.cwl:** Uses [Canu](https://github.com/marbl/canu). Trims and corrects reads and creates an assembly using an OLC strategy.

**necatWorkflow.cwl:** Uses [NECAT](https://github.com/xiaochuanle/NECAT) to correct reads and create an assembly using an OLC strategy.

**minasmX3Workflow.cwl:** Uses [minimap2](https://github.com/lh3/minimap2) to find overlapping regions between reads. [miniasm] will then create a draft assembly based on the overlaps. Three rounds of [minimap2](https://github.com/lh3/minimap2) and [racon](https://github.com/isovic/racon) are then used to create a consensus sequence.
### Polishing
**medakaTool.cwl:** Uses ONT's [medaka](https://github.com/nanoporetech/medaka) software to polish a draft assembly where the reads where basecalled with albacore or guppy.

**nanopolishWorkflow.cwl:** Uses [Nanopolish](https://github.com/jts/nanopolish) to polish an assembly based on the raw reads (a.k.a. squiggles).

**pilonWorkflow.cwl:** Uses [Pilon](https://github.com/broadinstitute/pilon) to polish a long-read-based draft assembly with short reads (e.g. Illumina reads).

# Containerization
Docker, Singularity or similar software is necessary to execute the tools in the docker containers that are assigned in each tool wrapper. If the execution environment does not support docker containers, tools have to be available locally. Every CWL document references a specific release of a Docker image from this directory. Images are available at [Docker Hub](https://hub.docker.com/u/ttubb). Please consult the Dockerfile to find out which software versions are used in an image.
# Installation
No installation is needed. Simply dowload a [release](https://github.com/ttubb/autopore/releases) or clone the repository using the command
```
git clone https://github.com/ttubb/autopore.git
```
Relative paths of the repository have to be preserved, otherwise workflows will not find the individual tools.
# Support
If you encounter any problems, please open a issue here on GitHub. I am also happy to implement additional tool wrappers or workflows if anybody needs them.
