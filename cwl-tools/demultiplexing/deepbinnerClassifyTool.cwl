#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: [deepbinner, classify]
label: Creates a list which matches input reads to one of the different barcodes based on the raw nanopore signal data.

hints:
  cwltool:LoadListingRequirement:
    loadListing: shallow_listing
  DockerRequirement:
    dockerPull: ttubb/deepbinner:release-0.2.0
  SoftwareRequirement:
    packages:
      deepbinner:
        specs: [ https://github.com/rrwick/Deepbinner ]
        version: [ "0.2.0" ]

inputs:
  barcoding_type:
    label: Tells deepbinner wether native (EXP-NBD103 read start and end models) or rapid (SQK-RBK004 read start model) was performed.
    type: string
    inputBinding:
      position: 1
  fast5_directory:
    label: Directory (will be searched recursively) containing fast5 files with raw nanopore signal data.
    type: Directory
    inputBinding:
      position: 2
  worker_threads:
    label: Number of CPU-threads used by tensorflow.
    type: int?
    default: 12
    inputBinding:
      position: 0
      prefix: --intra_op_parallelism_threads

outputs:
  classifications:
    label: List matching reads with barcodes.
    type: stdout

stdout: deepbinner_classifications

s:author:
  - class: s:Person
    s:email: mailto:tom.tubb@googlemail.com
    s:name: Tom Tubbesing
s:dateCreated: "2019-02-15"
s:license: https://spdx.org/licenses/GPL-3.0-or-later

$namespaces:
  s: "http://schema.org/"
  edam: "http://edamontology.org/"
  cwltool: "http://commonwl.org/cwltool#"

$schemas:
  - https://schema.org/version/latest/schema.rdf
  - http://edamontology.org/EDAM_1.20.owl
