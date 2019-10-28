#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow
label: Links the tool wrappers of wtdbg2 and wtpoa-cns to create a readbean (formerly wtdbg2) assembly

hints:
  SoftwareRequirement:
    packages:
      redbean/wtdbg2:
        specs: [ "https://github.com/ruanjue/wtdbg2" ]
        version: [ "2.5" ]

inputs:
  reads:
    label: File with basecalled long reads
    type: File
  preset:
    label: Presets for different read types
    doc: |
      rs for PacBio RSII
      sq for PacBio Sequel
      ccs for Pacbio CCS
      ont for Oxford Nanopore
      If a parameter determined by presets is also defined manually, manual input will override the respective preset value
    type: string
  worker_threads:
    label: Number of CPU threads used by tool
    type: int
    default: 1
  estimated_genome_size:
    label: (assembly step) Size estimation (e.g. 3000000 / 3m / 0.003g)
    type: string?
  subread_threshold:
    label: (assembly step) Choose the longest subread and drop reads shorter than <int> (5000 recommended for PacBio).
    type: int?
  kmer_fsize:
    label: (assembly step) 0 <= kmer_fsize <= 23
    type: int?
  kmer_psize:
    label: (assembly step) 0 <= kmer_psize <= 23
    type: int?
  high_frequency_kmer_filter:
    label: (assembly step) Filter for high frequency (potentially repetetive) kmers
    type: float?
  kmer_subsampling:
    label: (assembly step) 1/kmer_subsamling kmers are indexed, can reduce memory usage and cpu time
    type: float?
  min_alignment_length:
    label: (assembly step) Minimum length of alignment
    type: float?
  min_matched_length:
    label: (assembly step) Minumum matched length by kmer matching
    type: float?
  min_similarity:
    label: (assembly step) Minumum similarity, calculated by kmer_matched_length/aligned length
    type: float?
  min_read_depth:
    label: (assembly step) Minimum read depth of a valid edge
    type: float?
  realignment_mode:
    label: (assembly step) Enables realignment mode if true
    type: boolean?
  keep_contained_reads:
    label: (assembly step) Keeps contained reads during alignment if true
    type: boolean?
  node_max_length:
    label: (consensus step) Maximum expeted length of nodes
    type: int?
  tri_base_match_bonus:
    label: (consensus step) Bonus for tri-base-matches, defaults to 0
    type: int?
  match_score:
    label: (consensus step) defaults to 2
    type: int?
  mismatch_score:
    label: (consensus step) defaults to -5
    type: int?
  insertion_score:
    label: (consensus step) defaults to -2
    type: int?
  deletion_score:
    label: (consensus step) defaults to -4
    type: int?
  homopolymer_merge_score:
    label: (consensus step) used in dp-call-cns mode, defaults to -3
    type: float?


outputs:
  assembly:
    type: File
    outputSource: consensus/assembly
      

steps:
  assembly:
    run: redbeanAssemblyTool.cwl
    in:
      reads: reads
      preset: preset
      worker_threads: worker_threads
      estimated_genome_size: estimated_genome_size
      subread_threshold: subread_threshold
      kmer_fsize: kmer_fsize
      kmer_psize: kmer_psize
      high_frequence_kmer_filter: high_frequency_kmer_filter
      kmer_subsampling: kmer_subsampling
      min_alignment_length: min_alignment_length
      min_matched_length: min_matched_length
      min_similarity: min_similarity
      min_read_depth: min_read_depth
      realignment_mode: realignment_mode
      keep_contained_reads: keep_contained_reads
    out: [draft_assembly]
  consensus:
    run: redbeanConsensusTool.cwl
    in:
      assembly_layout: assembly/draft_assembly
      worker_threads: worker_threads
      node_max_length: node_max_length
      tri_base_match_bonus: tri_base_match_bonus
      match_score: match_score
      mismatch_score: mismatch_score
      insertion_score: insertion_score
      deletion_score: deletion_score
      homopolymer_merge_score: homopolymer_merge_score
    out: [assembly]

s:author:
  - class: s:Person
    s:email: mailto:tom.tubb@googlemail.com
    s:name: Tom Tubbesing
s:dateCreated: "2019-10-28"
s:license: "https://spdx.org/licenses/GPL-3.0-or-later.html"

$namespaces:
  s: "http://schema.org/"

$schemas:
  - http://schema.org/docs/schema_org_rdfa.html
