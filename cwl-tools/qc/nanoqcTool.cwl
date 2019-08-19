#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: nanoQC
label: Uses nanoQC to generate a quality control report based on fastq reads.
  
hints:
  DockerRequirement:
    dockerPull: ttubb/nanoqc:release-0.2.0
  SoftwareRequirement:
    packages:
      nanoqc:
        specs: [ https://github.com/wdecoster/nanoQC ]
        version: [ "0.9.0" ]

requirements:
  InlineJavascriptRequirement: {}

arguments:
  - valueFrom: nanoqc-report
    prefix: -o
    position: 0

inputs:
  reads:
    label: Basecalled nanopore reads in fastq format.
    type: File
    inputBinding:
      position: 1

outputs:
  report_directory:
    type: Directory
    label: Directory containing all nanoqc report data.
    outputBinding:
      glob: nanoqc-report
  logfile:
    label: Logfile.
    type: File
    outputBinding:
      glob: nanoqc-report/NanoQC.log
  report_html:
    label: Report in html format.
    type: File
    outputBinding:
      glob: nanoqc-report/nanoQC.html
    
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
