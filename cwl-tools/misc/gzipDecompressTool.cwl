#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: gzip
label: Decompresses a gzipped file.

hints:
  DockerRequirement:
    dockerPull: busybox
  SoftwareRequirement:
    packages:
      gzip:
        specs: [ https://identifiers.org/RRID:SCR_009291 ]
        version: [ "1.6" ]

requirements:
  InitialWorkDirRequirement:
    listing:
      - entry: $(inputs.zipped_file)
        writable: true

arguments:
  - valueFrom: -d
    position: 1

inputs:
  zipped_file:
    label: File in .gz format.
    type: File
    inputBinding:
      position: 2
    
outputs:
  unzipped_file:
    label: Decompressed zipped_file.
    type: File
    outputBinding:
      glob: $(inputs.zipped_file.nameroot)

s:author:
  - class: s:Person
    s:email: mailto:tom.tubb@googlemail.com
    s:name: Tom Tubbesing
s:dateCreated: "2019-05-13"
s:license: https://spdx.org/licenses/GPL-3.0-or-later

$namespaces:
  s: http://schema.org/

$schemas:
  - http://schema.org/docs/schema_org_rdfa.html
