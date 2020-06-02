#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow
label: Produces a polished de novo assembly from basecalled nanopore reads.
doc: |
  Creates a de novo assembly from a file of basecalled ONT nanopore reads. Then polishes this assembly using the corresponding raw ONT nanopore reads.

hints:
  cwltool:LoadListingRequirement:
    loadListing: shallow_listing
  SoftwareRequirement:
    packages:
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
  SubworkflowFeatureRequirement: {}
  InlineJavascriptRequirement: {}
  StepInputExpressionRequirement: {}

inputs:
  worker_threads:
    label: Number of CPU-threads used for computationally intensive steps.
    type: int
  reads:
    label: Basecalled ONT nanopore reads in fastq format.
    type: File
  estimated_genome_size:
    label: Size estimate for sequenced genome. Can be provided as in int (e.g. 3000000) or a string (e.g. 3m).
    type: [int, string]
  fast5_directory:
    label: Directory containing raw nanopore signal data in fast5 format.
    type: Directory

outputs:
  assembly_directory:
    label: Raw assembly produced by canu.
    type: ["null",Directory]
    outputSource: assembling/output_directory
  polished_assembly:
    label: canu assembly polished by nanopolish
    type: ["null",File]
    outputSource: polishing/polished_assembly

steps:
  assembling:
    label: Create de novo assembly from ONT nanopore reads.
    run: ../../cwl-tools/assembly/canuTool.cwl
    in:
      reads: reads
      estimated_genome_size: estimated_genome_size
    out: [output_directory, contigs, contigs_read_layout, contigs_graph, unassembled, unitigs, unitigs_read_layout, unitigs_graph, report]
  polishing:
    label: Polish draft assembly.
    run: ../../cwl-tools/polishing/nanopolishWorkflow.cwl
    in:
      worker_threads: worker_threads
      draft_genome: assembling/contigs
      fast5_directory: fast5_directory
      reads: reads
    out: [polished_assembly]

s:author:
  - class: s:Person
    s:email: mailto:tom.tubb@googlemail.com
    s:name: Tom Tubbesing
s:dateCreated: "2019-08-05"
s:license: "https://spdx.org/licenses/GPL-3.0-or-later.html"

$namespaces:
  s: "http://schema.org/"
  edam: "http://edamontology.org/"
  cwltool: "http://commonwl.org/cwltool#"

$schemas:
  - https://schema.org/version/latest/schema.rdf
