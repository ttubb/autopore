#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: [samtools, sort]
label: Sorts an alignment.

hints:
  DockerRequirement:
    dockerPull: ttubb/samtools:release-0.2.0
  SoftwareRequirement:
    packages:
      samtools:
        specs: [ "https://identifiers.org/RRID:SCR_002105" ]
        version: [ "1.7" ]

requirements:
  InlineJavascriptRequirement: {}

inputs:
  worker_threads:
    label: Number of CPU-threads used by tool.
    type: int
    inputBinding:
      position: 1
      separate: false
      prefix: -@
  alignment:
    label: Alignment with sequences to sort.
    type: File
    inputBinding:
      position: 2

outputs:
  sorted_alignment:
    label: File with sorted sequences.
    type: stdout
    format: edam:format_2573 #bam

stdout: $(inputs.alignment.nameroot+"_sorted.bam")


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
  - http://schema.org/docs/schema_org_rdfa.html
  - http://edamontology.org/EDAM_1.20.owl
