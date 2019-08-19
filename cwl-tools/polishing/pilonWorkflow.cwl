#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow
label: Uses Illumina short reads to polish a long read draft assembly.

hints:
  SoftwareRequirement:
    packages:
      bowtie2:
        specs: [ "https://github.com/BenLangmead/bowtie2" ]
        version: [ "2.3.5.1" ]
      pilon:
        specs: [ "https://identifiers.org/RRID:SCR_014731" ]
        version: [ "1.23" ]
      samtools:
        specs: [ "https://identifiers.org/RRID:SCR_002105" ]
        version: [ "1.7" ]
  
inputs:
  worker_threads:
    label: CPU threads used for computationally intensive steps.
    type: int
  draft_genome:
    label: draft genome created by assembler.
    type: File
  reads_fwd:
    label: Short read forward reads.
    type: File
  reads_rev:
    label: Short read reverse reads.
    type: File

outputs:
  polished_assembly:
    label: Polished version of draft_genome
    type: File
    outputSource: polishing/polished_assembly

steps:
  bowtie2_indexing:
    label: Create index for draft genome.
    run: ../mapping/bowtie2IndexTool.cwl
    in:
      reference: draft_genome
    out: [index_directory, index_files]
  mapping:
    label: Map short reads to index.
    run: ../mapping/bowtie2MappingTool.cwl
    in:
      worker_threads: worker_threads
      index_files: bowtie2_indexing/index_files
      reads_fwd: reads_fwd
      reads_rev: reads_rev
    out: [alignment_map]
  sam_sorting:
    label: Sort alignment map.
    run: ../misc/samtoolsSortTool.cwl
    in:
      worker_threads: worker_threads
      alignment: mapping/alignment_map
    out: [sorted_alignment]
  sam_indexing:
    label: Create index for alignment map.
    run: ../misc/samtoolsIndexTool.cwl
    in:
      worker_threads: worker_threads
      bamfile: sam_sorting/sorted_alignment
    out: [index]
  polishing:
    label: Polish draft genome.
    run: pilonTool.cwl
    in:
      worker_threads: worker_threads
      assembly: draft_genome
      frags: sam_sorting/sorted_alignment
      index: sam_indexing/index
    out: [polished_assembly, output_directory]

s:author:
  - class: s:Person
    s:email: mailto:tom.tubb@googlemail.com
    s:name: Tom Tubbesing
s:dateCreated: "2019-02-08"
s:license: "https://spdx.org/licenses/GPL-3.0-or-later.html"

$namespaces:
  s: http://schema.org/
  edam: http://edamontology.org/

$schemas:
  - http://schema.org/docs/schema_org_rdfa.html
  - http://edamontology.org/EDAM_1.20.owl
