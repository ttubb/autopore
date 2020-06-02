#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: [graphmap, align]
label:  Maps reads from a fastq file to the reference genome.

hints:
  DockerRequirement:
    dockerPull: ttubb/graphmap:release-0.2.0
  SoftwareRequirement:
    packages:
      graphmap:
        specs: [ https://anaconda.org/bioconda/graphmap ]
        version: [ "0.3.0" ]

requirements:
  InlineJavascriptRequirement: {}
  InitialWorkDirRequirement:
    listing: [$(inputs.reference_genome)]
        
inputs:
  worker_threads:
    label: Number of CPU-threads be used by tool.
    type : int
    inputBinding:
      prefix: --threads
  reference_genome:
    label: Reference genome to align reads to.
    type: File
    inputBinding:
      prefix: -r
  reads:
    label: File with long reads and quality scores.
    type: File
    inputBinding:
      prefix: -d

outputs:
  alignment_map:
    label: Alignment of reads to reference_genome
    type: stdout

stdout: $(inputs.reads.nameroot+"_alignment.bam")

s:author:
  - class: s:Person
    s:email: mailto:tom.tubb@googlemail.com
    s:name: Tom Tubbesing
s:dateCreated: "2019-02-08"
s:license: "https://spdx.org/licenses/GPL-3.0-or-later.html"

$namespaces:
  s: "http://schema.org/"
  edam: "http://edamontology.org/"

$schemas:
  - https://schema.org/version/latest/schema.rdf
  - http://edamontology.org/EDAM_1.20.owl
