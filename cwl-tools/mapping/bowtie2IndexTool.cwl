#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: bowtie2-build
label: Builds an index file for a fasta file to enable mapping in subsequent step.

hints:
  DockerRequirement:
    dockerPull: ttubb/bowtie2:release-0.2.0
  SoftwareRequirement:
    packages:
      bowtie2:
        specs: [ "https://github.com/BenLangmead/bowtie2" ]
        version: [ "2.3.5.1" ]

inputs:
  reference:
    label: fasta file of reference sequence to build index of.
    type: File
    inputBinding:
      position: 1
  index_prefix:
    label: Prefix of the index files which will be genrated.
    type: string
    default: "bowtie2-index"
    inputBinding:
      position: 2

outputs:
  index_files:
    label: array of all index files.
    type: File[]
    outputBinding:
      glob: "*.bt2"
  index_directory:
    label: directory containing all index files.
    type: Directory
    outputBinding:
      glob: .

s:author:
  - class: s:Person
    s:email: mailto:tom.tubb@googlemail.com
    s:name: Tom Tubbesing
s:dateCreated: "2019-02-08"
s:license: "https://spdx.org/licenses/GPL-3.0-or-later.html"

$namespaces:
  s: http://schema.org/
  edam: http://edamontology.org/

$schemas:
  - https://schema.org/version/latest/schema.rdf
  - http://edamontology.org/EDAM_1.20.owl
