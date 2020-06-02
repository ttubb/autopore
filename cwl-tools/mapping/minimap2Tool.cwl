#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: minimap2
label: Maps query sequences in fasta/fastq format against target sequences in fasta/fastq format.

hints:
  DockerRequirement:
    dockerPull: ttubb/minimap2:release-0.2.0
  SoftwareRequirement:
    packages:
      minimap2:
        specs: [ https://github.com/lh3/minimap2 ]
        version: [ "2.16" ]

requirements:
  InlineJavascriptRequirement: {}

inputs:
  preset:
    doc: |
      Determines which kind of operation will be performed:
      map-pb/map-ont: PacBio/Nanopore vs reference mapping
      ava-pb/ava-ont: PacBio/Nanopore read overlap
      asm5/asm10/asm20: asm-to-ref mapping
      splice: long-read spliced alignment
      sr: genomic short read mapping
    type: string?
    inputBinding:
      position: 0
      prefix: -x
  worker_threads:
    label: Number of CPU-threads used by minimap2.
    type: int?
    inputBinding:
      position: 1
      prefix: -t
  target:
    label: Target sequence in FASTQ/FASTA format (can be gzipped).
    type: File
    inputBinding:
      position: 2
  query:
    label: Query sequence in FASTQ/FASTA format (can be gzipped).
    type: File
    inputBinding:
      position: 3

outputs:
  alignment:
    label: Alignment of target vs query in PAF format (compressed as GZ).
    type: stdout
    
stdout: $(inputs.target.nameroot+".paf")

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
  - https://schema.org/version/latest/schema.rdf
  - http://edamontology.org/EDAM_1.20.owl
