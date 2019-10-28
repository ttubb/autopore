#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: flye
label: Tool wrapper for the flye de novo long read assembler.

hints:
  DockerRequirement:
    dockerPull: ttubb/flye:2.6
  SoftwareRequirement:
    packages:
      flye:
        specs: [ "https://github.com/fenderglass/Flye/" ]
        version: [ "2.6" ]

arguments:
  - valueFrom: "flye-output" #name of output directory
    prefix: --out-dir

inputs:
  reads:
    label: Corrected or uncorrected pacbio or nanopore reads to assemble
    type:
      - type: record
        name: pacbio_raw_reads
        fields:
          pacbio_raw_reads:
            type: File
            inputBinding:
              prefix: --pacbio-raw
      - type: record
        name: pacbio_corrected_reads
        fields:
          pacbio_corrected_reads:
            type: File
            inputBinding:
              prefix: --pacbio-corr
      - type: record
        name: nanopore_raw_reads
        fields:
          nanopore_raw_reads:
            type: File
            inputBinding:
              prefix: --nano-raw
      - type: record
        name: nanopore_corrected_reads
        fields:
          nanopore_corrected_reads:
            type: File
            inputBinding:
              prefix: --nano-corr
  worker_threads:
    label: Number of CPU threads used by tool
    type: int
    default: 1
    inputBinding:
      prefix: --threads
  estimated_genome_size:
    label: Size estimation (e.g. 3000000 / 3m / 0.003g)
    type: string?
    inputBinding:
      prefix: --genome-size
  polishing_iterations:
    label: Flye will carry out polishing multiple times as determined here
    type: int
    default: 1
    inputBinding:
      prefix: --iterations
  minimum_read_overlap:
    label: Minimum overlap between individual reads
    type: int?
    inputBinding:
      prefix: --min-overlap
  metagenome:
    label: Set to true if assembling a metagenome
    type: boolean
    default: False
    inputBinding:
      prefix: --meta
  skip_trestle:
    label: Set to true to skip the Trestle stage of flye
    type: boolean
    default: false
    inputBinding:
      prefix: --no-trestle
  rescue_short_plasmids:
    label: Set to true to rescue short unassembled plasmids
    type: boolean
    default: false
    inputBinding:
      prefix: --plasmids
  debug_mode:
    label: Set to true to display debug output while running
    type: boolean
    default: false
    inputBinding:
      prefix: --debug

outputs:
  draft_assembly:
    label: Non-polished assembly created by flye
    type: File
    outputBinding:
      glob: flye-output/00-assembly/draft_assembly.fasta
  assembly:
    label: Polished assembly created by flye
    type: File
    outputBinding:
      glob: flye-output/assembly.fasta
  output_directory:
    label: Directory containing all output produced by flye
    type: Directory
    outputBinding:
      glob: flye-output

s:author:
  - class: s:Person
    s:email: mailto:tom.tubb@googlemail.com
    s:name: Tom Tubbesing
s:dateCreated: "2019-10-24"
s:license: "https://spdx.org/licenses/GPL-3.0-or-later.html"

$namespaces:
  s: "http://schema.org/"

$schemas:
  - http://schema.org/docs/schema_org_rdfa.html
