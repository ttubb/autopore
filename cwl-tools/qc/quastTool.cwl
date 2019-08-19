#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: quast.py
label: Uses quast to assess an assembly.

hints:
  DockerRequirement:
    dockerPull: ttubb/quast:release-0.2.0
  SoftwareRequirement:
    packages:
      quast:
        specs: [ https://identifiers.org/RRID:SCR_001228 ]
        version: [ "5.0.2" ]

requirements:
  InlineJavascriptRequirement: {}

arguments:
  - valueFrom: $("quast-report-for-"+(inputs.assembly.nameroot))
    position: 0
    prefix: --output-dir

inputs:
  assembly:
    label: Assembly which quast will assess.
    type: File
    inputBinding:
      position: 6
  reference_genome:
    label: File containing reference genome (optional).
    type: File?
    inputBinding:
      prefix: -r
      position: 1
  feature_coordinates:
    label: File with genomic feature coordinates in the reference (GFF, BED, NCBI or TXT) (optional).
    type: File?
    inputBinding:
      prefix: --features
      position: 2
  min_contig:
    label: Lower threshold for contig length (optional).
    type: int
    default: 500
    inputBinding:
      prefix: --min-contig
      position: 3
  worker_threads:
    label: CPU-threads used by tool.
    type: int
    default: 1
    inputBinding:
      prefix: --threads
      position: 4

outputs:
  report_directory:
    type: Directory
    label: Directory containing all quast report data.
    outputBinding:
      glob: $("quast-report-for-"+(inputs.assembly.nameroot))

s:author:
  - class: s:Person
    s:email: mailto:tom.tubb@googlemail.com
    s:name: Tom Tubbesing
s:dateCreated: "2019-05-16"
s:license: "https://spdx.org/licenses/GPL-3.0-or-later.html"

$namespaces:
  s: http://schema.org/
  edam: http://edamontology.org/

$schemas:
  - http://schema.org/docs/schema_org_rdfa.html
  - http://edamontology.org/EDAM_1.20.owl
