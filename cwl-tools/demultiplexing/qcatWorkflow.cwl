#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow
label: Demultiplexes barcoded nanopore reads.

hints:
  SoftwareRequirement:
    packages:
      qcat:
        specs: [ "https://github.com/nanoporetech/qcat" ]
        version: [ "1.1.0" ]

requirements:
  StepInputExpressionRequirement: {}
  InlineJavascriptRequirement: {}
  
inputs:
  reads:
    label: Basecalled nanopore reads in fastq format.
    type: File
  kit_id:
    label: Identifier of kit used in nanopore experiment
    type: string
  worker_threads:
    label: Number of CPU-threads used for demultiplexing step
    type: int
  adapter_trimming:
    label: Determines whether qcat will trim known adapters.
    type: boolean
    default: False
  min_read_length:
    label: qcat will discard all reads shorter than specified length.
    type: int?
  demultiplexing_mode:
    label: Determines demultiplexing algorithm. Choices are guppy, epi2me, dual
    type: string?
    default: guppy

outputs:
  unclassified_reads_directory:
    label: Reads that could not be matched to a barcode.
    type: [Directory]
    outputSource: create_unclassified_dir/unclassified_reads_directory
  barcoding_summary:
    label: Standard output produced by qcat, contains summary of demultiplexing process.
    type: File
    outputSource: demultiplexing/standard_out
  reads_by_barcode_array:
    label: Array of files, with each file continaing the reads that were matched to one specific barcode.
    type: File[]
    outputSource: demultiplexing/reads_by_barcode_array

steps:
  translate_kit_id:
    label: Translate a kit ID from the format that Guppy expects (e.g. SQK-RBK004) to the format used by medaka (e.g. RBK004).
    run:
      class: ExpressionTool
      inputs:
        kit_id:
          type: string
      outputs:
        short_id:
          type: string
      expression: |
        ${
          var new_id = inputs.kit_id;
          new_id = new_id.slice(-6);
          return {short_id: new_id}
          }
    in:
      kit_id: kit_id
    out: [short_id]
  demultiplexing:
    label: Use qcat to carry out demultiplexing.
    run: qcatTool.cwl
    in:
      reads: reads
      worker_threads: worker_threads
      kit_id: translate_kit_id/short_id
      adapter_trimming: adapter_trimming
      min_read_length: min_read_length
      demultiplexing_mode: demultiplexing_mode
    out: [reads_by_barcode_array, unclassified_reads, standard_out]
  create_unclassified_dir:
    label: Create a directory containing all unclassified reads.
    run:
      class: ExpressionTool
      inputs:
        unclassified_reads:
          type: [File, "null"]
      outputs:
        unclassified_reads_directory:
          type: Directory
      expression: |
        ${
          return {"unclassified_reads_directory": {
            "class": "Directory",
            "basename": "unclassified_reads",
            "listing": [inputs.unclassified_reads]
          } };
        }
    in:
      unclassified_reads: demultiplexing/unclassified_reads
    out: [unclassified_reads_directory]

s:author:
  - class: s:Person
    s:email: mailto:tom.tubb@googlemail.com
    s:name: Tom Tubbesing
s:dateCreated: "2019-04-28"
s:license: "https://spdx.org/licenses/GPL-3.0-or-later.html"

$namespaces:
  s: "http://schema.org/"

$schemas:
  - http://schema.org/docs/schema_org_rdfa.html
