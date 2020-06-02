#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: fastqc
label: Generates qc data pertaining to the reads given as input.

hints:
  DockerRequirement:
    dockerPull: biocontainers/fastqc:v0.11.5_cv3
  SoftwareRequirement:
    packages:
      fastqc:
        specs: [ https://identifiers.org/RRID:SCR_014583 ]
        version: [ "0.11.5" ]

requirements:
  InlineJavascriptRequirement: {}
  InitialWorkDirRequirement:
    listing:
      - entry: "$({class: 'Directory', listing: []})"
        entryname: "fastqc-report"
        writable: true

arguments:
  - valueFrom: "fastqc-report"
    position: 1
    prefix: --outdir

inputs:
  reads:
    label: File containing reads to be analyzed.
    type: File
    inputBinding:
      position: 2
  worker_threads:
    label: Number of CPU-threads used by tool.
    type: int
    default: 1
    inputBinding:
      position: 0
      prefix: --threads

outputs:
  report_directory:
    type: Directory
    label: Directory containing all fastqc report data.
    outputBinding:
      glob: "fastqc-report"
  report_html:
    label: FastQC report in .html format.
    type: File
    outputBinding:
      glob: $("fastqc-report/"+inputs.reads.nameroot+"_fastqc.html")
  report_zip:
    label: Archive with FastQC report data
    type: File
    outputBinding:
      glob: $("fastqc-report/"+inputs.reads.nameroot+"_fastqc.zip")

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
  - https://schema.org/version/latest/schema.rdf
  - http://edamontology.org/EDAM_1.20.owl
