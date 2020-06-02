#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: [nanopolish, index]
label: Uses nanopolish to create an index of nanopore raw data and corresponding basecalled reads.

hints:
  cwltool:LoadListingRequirement:
    loadListing: shallow_listing
  DockerRequirement:
    dockerPull: ttubb/nanopolish:0.11.2
  SoftwareRequirement:
    packages:
      nanopolish:
        specs: [ https://identifiers.org/rrid/RRID:SCR_016157 ]
        version: [ "0.11.2" ]

requirements:
  InlineJavascriptRequirement: {}
  InitialWorkDirRequirement:
    listing: [ $(inputs.reads) ]

inputs:
  fast5_directory:
    label: Directory containing raw nanopore signal data in fast5 format.
    type: Directory
    inputBinding:
      prefix: -d
      position: 1
  reads:
    label: Basecalled reads with quality scores.
    type: File
    inputBinding:
      position: 3

outputs:
  reads_with_index:
    label: reads file with index data attached as secondaryFile.
    type: File
    secondaryFiles: [.index, .index.fai, .index.gzi, .index.readdb]
    outputBinding:
      glob: $(inputs.reads.basename)

s:author:
  - class: s:Person
    s:email: mailto:tom.tubb@googlemail.com
    s:name: Tom Tubbesing
s:dateCreated: "2019-02-08"
s:license: "https://spdx.org/licenses/GPL-3.0-or-later.html"

$namespaces:
  s: "http://schema.org/"
  edam: "http://edamontology.org/"
  cwltool: "http://commonwl.org/cwltool#"

$schemas:
  - https://schema.org/version/latest/schema.rdf
  - http://edamontology.org/EDAM_1.18.owl
