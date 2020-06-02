#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow
label: Produces a polished de novo assembly from basecalled, barcoded ONT nanopore reads.
doc: |
  This workflow takes a directory of barcoded raw ONT nanopore reads with the corresponding basecalled reads as input and performs demultiplexing, adapter trimming, assembling and polishing.

hints:
  cwltool:LoadListingRequirement:
    loadListing: shallow_listing
  SoftwareRequirement:
    packages:
      deepbinner:
        specs: [ https://github.com/rrwick/Deepbinner ]
        version: [ "0.2.0" ]
      porechop:
        specs: [ https://identifiers.org/RRID:SCR_016967 ]
        version: [ "0.2.4" ]
      canu:
        specs: [ "https://identifiers.org/RRID:SCR_015880" ]
        version: [ "1.8" ]
      nanopolish:
        specs: [ https://identifiers.org/rrid/RRID:SCR_016157 ]
        version: [ "0.11.1" ]
      graphmap:
        specs: [ https://anaconda.org/bioconda/graphmap ]
        version: [ "0.3.0" ]

requirements:
  InlineJavascriptRequirement: {}
  SubworkflowFeatureRequirement: {}
  ScatterFeatureRequirement: {}
  MultipleInputFeatureRequirement: {}
  StepInputExpressionRequirement: {}

inputs:
  worker_threads:
    label: Number of CPU-threads used in computationally intensive steps.
    type: int
    default: 1
  kit_id:
    label: Identifier of kit used in nanopore experiment (e.g. SQK-RBK004).
    type: string
  fast5_directory:
    label: Directory containing raw nanopore signal data in single-read fast5 format.
    type: Directory
  reads:
    label: File containing basecalled nanopore reads in fastq format.
    type: File
  estimated_genome_size:
    label: Size estimate for sequenced genome. Can be provided as in int (e.g. 3000000) or a string (e.g. 3m).
    type: [int, string]
  
outputs:
  assembly_directories:
    label: Directories containung all canu assembly results.
    type: Directory[]
    outputSource: assembling_and_polishing/assembly_directory
  polished_assemblies:
    label: Polished assemblies
    type: File[]
    outputSource: assembling_and_polishing/polished_assembly
  demultiplexed_reads:
    label: Reads for each barcode.
    type: File[]
    outputSource: demultiplexing/reads_by_barcode_array
  unclassified_reads:
    label: Reads which could not be matched to a barcode.
    type: ["null",File]
    outputSource: demultiplexing/unclassified_reads

steps:
  demultiplexing:
    label: Demultiplexes barcoded reads.
    run: ../cwl-tools/demultiplexing/deepbinnerWorkflow.cwl
    in:
      worker_threads: worker_threads
      reads: reads
      fast5_directory: fast5_directory
      kit_id: kit_id
    out: [reads_by_barcode_array, unclassified_reads]
  trimming:
    label: Trims adapters from reads.
    run: ../cwl-tools/misc/porechopTool.cwl
    scatter: reads
    in:
      reads: demultiplexing/reads_by_barcode_array
      worker_threads: worker_threads
    out: [trimmed_reads]
  assembling_and_polishing:
    label: Assembles reads and then polishes the assembly.
    run: subworkflows/canopolishWorkflow.cwl
    scatter: [reads]
    in:
      worker_threads: worker_threads
      reads: trimming/trimmed_reads
      estimated_genome_size: estimated_genome_size
      fast5_directory: fast5_directory
    out: [assembly_directory, polished_assembly]
 
s:author:
  - class: s:Person
    s:email: mailto:tom.tubb@googlemail.com
    s:name: Tom Tubbesing
s:dateCreated: "2019-06-26"
s:license: "https://spdx.org/licenses/GPL-3.0-or-later.html"

$namespaces:
  s: "http://schema.org/"
  edam: "http://edamontology.org/"
  cwltool: "http://commonwl.org/cwltool#"

$schemas:
  - https://schema.org/version/latest/schema.rdf
  - http://edamontology.org/EDAM_1.18.owl
    
  
