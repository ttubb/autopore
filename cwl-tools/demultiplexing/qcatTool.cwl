#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: qcat
label: Demultiplexes barcoded nanopore reads.

hints:
  DockerRequirement:
    dockerPull: ttubb/qcat:release-0.2.0
  SoftwareRequirement:
    packages:
      qcat:
        specs: [ "https://github.com/nanoporetech/qcat" ]
        version: [ "1.1.0" ]

arguments:
  - valueFrom: . #Set CWLs runtime output directory as output directory for demultiplexed barcodes
    prefix: --barcode_dir
  
inputs:
  reads:
    label: Basecalled nanopore reads in fastq format.
    type: File
    inputBinding:
      prefix: --fastq
  worker_threads:
    label: Number of CPU-threads used by tool.
    type: int?
    inputBinding:
      prefix: --threads
  adapter_trimming:
    label: Determines whether qcat will trim known adapters.
    type: boolean?
    inputBinding:
      prefix: --trim
  min_read_length:
    label: qcat will discard all reads shorter than specified length.
    type: int?
    inputBinding:
      prefix: --min-read-length
  demultiplexing_mode:
    label: Determines demultiplexing algorithm. Choices are guppy, epi2me, dual
    type: string?
    default: guppy
    inputBinding:
      prefix: --
      separate: False
  kit_id:
    label: Specifies the barcoding kit that was used during experiment (e.g. RBK004). Will try to auto-determine kit by default. 
    type: string?
    inputBinding:
      prefix: --kit

outputs:
  reads_by_barcode_array:
    label: Array of files, with each file containing the reads that were matched to one specific barcode.
    type: File[]
    outputBinding:
      glob: barcode*.fastq
  unclassified_reads:
    label: Reads that could not be matched to a barcode.
    type: [File, "null"]
    outputBinding:
      glob: none.fastq
  standard_out:
    label: Logfile containing stdout.
    type: stdout

stdout: qcat_demultiplexing_summary
    
s:author:
  - class: s:Person
    s:email: mailto:tom.tubb@googlemail.com
    s:name: Tom Tubbesing
s:dateCreated: "2019-04-28"
s:license: "https://spdx.org/licenses/GPL-3.0-or-later.html"

$namespaces:
  s: "http://schema.org/"

$schemas:
  - https://schema.org/version/latest/schema.rdf
