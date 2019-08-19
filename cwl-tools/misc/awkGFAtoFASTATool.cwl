#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: awk
label: Converts the input gfa file to fasta format.

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

arguments: ['/^S/{print ">"$2"\n"$3}']

inputs:
  input_file:
    label: File in GFA format which will be converted to fasta format.
    type: File
    inputBinding:
      position: 2

outputs:
  converted_file:
    label: input_file which was converted to fasta format
    type: stdout

stdout: $(inputs.input_file.nameroot+".fasta")

s:author:
  - class: s:Person
    s:email: mailto:tom.tubb@googlemail.com
    s:name: Tom Tubbesing
s:dateCreated: "2019-05-15"
s:license: https://spdx.org/licenses/GPL-3.0-or-later

$namespaces:
  s: http://schema.org/
  edam: http://edamontology.org/

$schemas:
  - http://schema.org/docs/schema_org_rdfa.html
  - http://edamontology.org/EDAM_1.20.owl
