#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow
label: Uses necat to create an assembly from raw ONT nanopore reads.
doc: |
  This workflow uses the various modules of the Necat assembler to create a de novo assembly from basecalled nanopore reads. Since the core modules of necat need a config file to work, the first three steps of the workflow create such a config file based on the input given to the workflow.

hints:
  SoftwareRequirement:
    packages:
      necat:
        specs: [ "https://github.com/xiaochuanle/NECAT" ]
        version: [ "0.01" ]

requirements:
  StepInputExpressionRequirement: {}
  InlineJavascriptRequirement: {}

inputs:
  reads:
    label: fastq file containing basecalled ONT nanopore reads.
    type: File
  worker_threads:
    label: Number of CPU-threads used in computationally intensive steps.
    type: int
  estimated_genome_size:
    label: Size estimate (in bp) for the genome that was sequenced.
    type: int

outputs:
  contigs:
    label: File with contigs assembled from nanopore read data.
    type: File
    outputSource: rename_assembly/file_renamed
  
steps:
  generate_config:
    label: Generates a necat config file.
    run: necatConfigTool.cwl
    in:
      configname:
        valueFrom: newconfig.txt
    out: [necat_config]
  generate_reads_list:
    label: Generates a file with a list of all reads.
    run: necatReadListPrepTool.cwl
    in:
      reads: reads
    out: [reads_list]
  fill_in_config:
    label: Fills in the config file with all necessary information for assembly.
    run: necatConfigPrepTool.cwl
    in:
      config: generate_config/necat_config
      reads_list: generate_reads_list/reads_list
      project_name:
        valueFrom: necatassembly
      estimated_genome_size: estimated_genome_size
      worker_threads: worker_threads
    out: [filled_config]
  assembly:
    label: Corrects reads, generates contigs, bridges contigs, producing an assembly.
    run: necatBridgeTool.cwl
    in:
      necat_config: fill_in_config/filled_config
      reads_list: generate_reads_list/reads_list
      reads: reads
    out: [contigs]
  rename_assembly:
    label: Changes name of the assembly file.
    run: ../misc/renameTool.cwl
    in:
      namesource: reads
      newname:
        valueFrom: $((inputs.namesource.nameroot)+"_necat_contigs.fasta")
      rename_this: assembly/contigs
    out: [file_renamed]

s:author:
  - class: s:Person
    s:email: mailto:tom.tubb@googlemail.com
    s:name: Tom Tubbesing
s:dateCreated: "2019-04-11"
s:license: "https://spdx.org/licenses/GPL-3.0-or-later.html"

$namespaces:
  s: "http://schema.org/"
  edam: "http://edamontology.org/"
  cwltool: "http://commonwl.org/cwltool#"

$schemas:
  - https://schema.org/version/latest/schema.rdf
  - http://edamontology.org/EDAM_1.18.owl
