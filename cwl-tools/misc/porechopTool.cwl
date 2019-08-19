#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: porechop
label: Uses porechop to trim adapters from nanopore reads. Does not support barcode binning or advanced adapter settings.

hints:
  DockerRequirement:
    dockerPull: ttubb/porechop:release-0.2.0
  SoftwareRequirement:
    packages:
      porechop:
        specs: [ https://identifiers.org/RRID:SCR_016967 ]
        version: [ "0.2.4" ]
          
requirements:
  InlineJavascriptRequirement: {}

inputs:
  reads:
    label: Reads with adapters.
    type: [File, Directory]
    inputBinding:
      prefix: --input
  output_format:
    label: Output format for reads. Has to be one of (auto,fasta,fastq,fasta.gz,fastq.gz). If not set, format will be chosen based format of input reads.
    type: string?
    inputBinding:
      prefix: --format
  worker_threads:
    label: Number of CPU-threads used by tool.
    type: int?
    inputBinding:
      prefix: --threads

outputs:
  trimmed_reads:
    label: Trimmed version of reads in same file format (or format specified by output_format).
    type: stdout

stdout: $("trimmed_"+(inputs.reads.basename))

s:author:
  - class: s:Person
    s:email: mailto:tom.tubb@googlemail.com
    s:name: Tom Tubbesing
s:dateCreated: "2019-05-18"
s:license: https://spdx.org/licenses/GPL-3.0-or-later

$namespaces:
  s: http://schema.org/

$schemas:
  - http://schema.org/docs/schema_org_rdfa.html
