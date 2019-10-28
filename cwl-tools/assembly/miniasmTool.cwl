#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: miniasm
label: Assembles long reads (pacbio or nanopore) based on an all vs all mapping of those reads. Constructs a .gfa file containing the unitig layout as output.

hints:
  DockerRequirement:
    dockerPull: ttubb/miniasm:0.3
  SoftwareRequirement:
    packages:
      miniasm:
        specs: [ https://biosphere.france-bioinformatique.fr/wikia2/index.php/Miniasm
                 https://github.com/lh3/miniasm ]
        version: [ "0.3" ]

requirements:
  InlineJavascriptRequirement: {}

inputs:
  reads:
    label: Reads to assemble, in fastq or fasta format.
    type: File?
    inputBinding:
      position: 2
      prefix: -f
  pairwise_alignment:
    label: Alignment map of reads against themselves in .paf format.
    type: File
    inputBinding:
      position: 3
  small_unitig_threshold:
    label: Unitigs comprising less reads will be discarded. Will default to 4 if not set.
    type: int?
    inputBinding:
      position: 1
      prefix: -e
  overlap_removal_rounds:
    label: Round of short overlap removal. Will default to 3 if not set.
    type: int?
    inputBinding:
      position: 1
      prefix: -n

outputs:
  unitigs_layout:
    label: Layout of unitigs generated from reads.
    type: stdout

stdout: $(inputs.reads.nameroot+"_unitig_layout.gfa")

s:author:
  - class: s:Person
    s:email: mailto:tom.tubb@googlemail.com
    s:name: Tom Tubbesing
s:dateCreated: "2019-05-15"
s:license: https://spdx.org/licenses/GPL-3.0-or-later

$namespaces:
  s: http://schema.org/
  edam: http://edamontology.org/

$schemas:
  - http://schema.org/docs/schema_org_rdfa.html
  - http://edamontology.org/EDAM_1.20.owl
