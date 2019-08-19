#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: [nanopolish, variants, --consensus]
label: Uses nanopolish to polish an assembly of nanopore data.

hints:
  DockerRequirement:
    dockerPull: ttubb/nanopolish:release-0.2.0
  SoftwareRequirement:
    packages:
      nanopolish:
        specs: [ https://identifiers.org/rrid/RRID:SCR_016157 ]
        version: [ "0.11.1" ]
        
requirements:
  InlineJavascriptRequirement: {}
  InitialWorkDirRequirement:
    listing:
      - $(inputs.draft_genome)
      - $(inputs.alignment_map)
      - $(inputs.alignment_map_index)
        
arguments:
  - valueFrom: $(inputs.draft_genome.nameroot+"_nanopolished.vcf")
    prefix: -o

inputs:
  worker_threads:
    label: Number of CPU-threads used by tool.
    type: int
    inputBinding:
      prefix: --threads=
      separate: false
  reads_with_index:
    label: Reads with quality scores with indices provided as secondaryFile.
    type: File
    secondaryFiles: [.index, .index.fai, .index.gzi, .index.readdb]
    inputBinding:
      prefix: --reads
  alignment_map:
    label: Mapping of reads to draft genome.
    type: File
    inputBinding:
      prefix: --bam
  alignment_map_index:
    label: Index file for the alignment map.
    type: File
  draft_genome:
    label: Draft genome created by assembler.
    type: File
    inputBinding:
      prefix: --genome
  contig_window:
    label: Specifies which section of the draft genome to polish.
    type: string
    inputBinding:
      prefix: -w

outputs:
  variant_calls:
    label: Polished version of draft genome.
    type: File
    outputBinding:
      glob: $(inputs.draft_genome.nameroot+"_nanopolished.vcf")

s:author:
  - class: s:Person
    s:email: mailto:tom.tubb@googlemail.com
    s:name: Tom Tubbesing
s:dateCreated: "2019-02-11"
s:license: "https://spdx.org/licenses/GPL-3.0-or-later.html"

$namespaces:
  s: http://schema.org/
  edam: http://edamontology.org/

$schemas:
  - http://schema.org/docs/schema_org_rdfa.html
  - http://edamontology.org/EDAM_1.18.owl
