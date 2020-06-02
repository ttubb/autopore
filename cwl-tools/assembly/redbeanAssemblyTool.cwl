#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: wtdbg2
label: Tool wrapper for the redbean (formerly wtdbg2) assembler module

hints:
  DockerRequirement:
    dockerPull: ttubb/redbean:2.5
  SoftwareRequirement:
    packages:
      redbean/wtdbg2:
        specs: [ "https://github.com/ruanjue/wtdbg2" ]
        version: [ "2.5" ]

arguments:
  - valueFrom: "redbean" #prefix of output files
    position: 1
    prefix: -o

inputs:
  reads:
    label: File with basecalled long reads
    type: File
    inputBinding:
      position: 2
      prefix: -i
  preset:
    label: Presets for different read types
    doc: |
      rs for PacBio RSII
      sq for PacBio Sequel
      ccs for Pacbio CCS
      ont for Oxford Nanopore
      If a parameter determined by presets is also defined manually, manual input will override the respective preset value
    type: string
    inputBinding:
      position: 3
      prefix: -x
  worker_threads:
    label: Number of CPU threads used by tool
    type: int
    default: 1
    inputBinding:
      position: 4
      prefix: -t
  estimated_genome_size:
    label: Size estimation (e.g. 3000000 / 3m / 0.003g)
    type: string?
    inputBinding:
      position: 4
      prefix: -g
  subread_threshold:
    label: Choose the longest subread and drop reads shorter than <int> (5000 recommended for PacBio).
    type: int?
    inputBinding:
      position: 5
      prefix: -L
  kmer_fsize:
    label: 0 <= kmer_fsize <= 23
    type: int?
    inputBinding:
      position: 5
      prefix: -k
  kmer_psize:
    label: 0 <= kmer_psize <= 23
    type: int?
    inputBinding:
      position: 5
      prefix: -p
  high_frequency_kmer_filter:
    label: Filter for high frequency (potentially repetetive) kmers
    type: float?
    inputBinding:
      position: 5
      prefix: -K
  kmer_subsampling:
    label: 1/kmer_subsamling kmers are indexed, can reduce memory usage and cpu time
    type: float?
    inputBinding:
      position: 5
      prefix: -S
  min_alignment_length:
    label: Minimum length of alignment
    type: float?
    inputBinding:
      position: 5
      prefix: -l
  min_matched_length:
    label: Minumum matched length by kmer matching
    type: float?
    inputBinding:
      position: 5
      prefix: -m
  min_similarity:
    label: Minumum similarity, calculated by kmer_matched_length/aligned length
    type: float?
    inputBinding:
      position: 5
      prefix: -s
  min_read_depth:
    label: Minimum read depth of a valid edge
    type: float?
    inputBinding:
      position: 5
      prefix: -e
  realignment_mode:
    label: Enables realignment mode if true
    type: boolean?
    inputBinding:
      position: 5
      prefix: -R
  keep_contained_reads:
    label: Keeps contained reads during alignment if true
    type: boolean?
    inputBinding:
      position:  5
      prefix: -A

outputs:
  draft_assembly:
    type: File
    outputBinding:
      glob: redbean.ctg.lay.gz

s:author:
  - class: s:Person
    s:email: mailto:tom.tubb@googlemail.com
    s:name: Tom Tubbesing
s:dateCreated: "2019-10-24"
s:license: "https://spdx.org/licenses/GPL-3.0-or-later.html"

$namespaces:
  s: "http://schema.org/"

$schemas:
  - https://schema.org/version/latest/schema.rdf
