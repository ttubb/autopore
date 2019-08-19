#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: [samtools, index]
label: Builds a BAI index for a given input bam file. Returns the same file and provides the newly built index as a secondaryFile.

hints:
  DockerRequirement:
    dockerPull:
      ttubb/samtools:release-0.2.0
  SoftwareRequirement:
    packages:
      samtools:
        specs: [ "https://identifiers.org/RRID:SCR_002105" ]
        version: [ "1.7" ]

requirements:
  InlineJavascriptRequirement: {}
  InitialWorkDirRequirement:
   listing:
     - entry: $(inputs.bamfile)
       writable: true

arguments:
  - valueFrom: -b #Index will be created in BAI format
    position: 1

inputs:
  worker_threads:
    label: Number of CPU-threads used by tool.
    type: int
    inputBinding:
      prefix: -@
      separate: false
      position: 2
  bamfile:
    label: Alignment map which this tool will build an index for.
    type: File
    inputBinding:
      position: 3

outputs:
  index:
    label: Index for the input bam file.
    type: File
    outputBinding:
      glob: $(inputs.bamfile.basename+".bai")

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
