#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: cat
label: Merges the contents of an array of fastq files into a single file.

hints:
  DockerRequirement:
    dockerPull: busybox
    
requirements:
  InlineJavascriptRequirement: {}

inputs:
  array_of_reads:
    label: Array of fastq files containing reads.
    type: File[]
    inputBinding:
      separate: true
  namesource_directory:
    label: Folder containing the reads, only needed for naming purposes.
    type: Directory

outputs:
  merged_reads:
    label: Concatenation of all reads present in array_of_reads.
    type: stdout
    
stdout: $(inputs.namesource_directory.basename+"_merged_reads.fastq")

s:author:
  - class: s:Person
    s:email: mailto:tom.tubb@googlemail.com
    s:name: Tom Tubbesing
s:dateCreated: "2019-01-17"
s:license: https://spdx.org/licenses/GPL-3.0-or-later

$namespaces:
  s: http://schema.org/
  edam: http://edamontology.org/

$schemas:
  - https://schema.org/version/latest/schema.rdf
  - http://edamontology.org/EDAM_1.20.owl
