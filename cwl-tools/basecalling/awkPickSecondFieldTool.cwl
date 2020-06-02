#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: awk
label: Print the second field of each line in inp_record and return the result as a file. Intended to isolate the read IDs of ONT nanopore reads from other information.

hints:
  DockerRequirement:
    dockerPull: busybox
  SoftwareRequirement:
    packages:
      awk:
        specs: [ https://pubs.opengroup.org/onlinepubs/9699919799/utilities/awk.html ]
        version: [ "4.1.4" ]

requirements:
  InlineJavascriptRequirement: {}

arguments: ['{print $2}']

inputs:
  inp_record:
    label: Textfile with multiple fields in each line.
    type: File
    inputBinding:
      position: 2
      
outputs:
  outp_record:
    label: Textfile with only one the second field from the input file in each line. 
    type: stdout

stdout: $(inputs.inp_record.basename)

s:author:
  - class: s:Person
    s:email: mailto:tom.tubb@googlemail.com
    s:name: Tom Tubbesing
s:dateCreated: "2019-04-16"
s:license: "https://spdx.org/licenses/GPL-3.0-or-later.html"

$namespaces:
  s: http://schema.org/
  edam: http://edamontology.org/

$schemas:
  - https://schema.org/version/latest/schema.rdf
  - http://edamontology.org/EDAM_1.18.owl
