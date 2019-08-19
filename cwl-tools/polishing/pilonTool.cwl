#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: [java, -jar, /software/pilon.jar]
label: Uses pilon to polish a draft assembly with short reads.

hints:
  DockerRequirement:
    dockerPull: ttubb/pilon:release-0.2.0
  SoftwareRequirement:
    packages:
      pilon:
        specs: [ "https://identifiers.org/RRID:SCR_014731" ]
        version: [ "1.23" ]
    
requirements:
  InlineJavascriptRequirement: {}
  InitialWorkDirRequirement:
    listing:
      - $(inputs.index)
      - $(inputs.frags)

arguments:
  - valueFrom: $((inputs.assembly.nameroot)+"_pilon_polished") #output prefix
    prefix: --output
  - valueFrom: . #output directory
    prefix: --outdir 

inputs:
  assembly:
    label: The draft assembly this tool will try to improve.
    type: File
    inputBinding:
      prefix: --genome
  frags:
    label: bam file of paired-end ngs reads aligned to the assembly.
    type: File
    inputBinding:
      prefix: --frags
  index:
    label: Index for bam file.
    type: File
  jumps:
    label: bam file of mate pair paired-end ngs reads aligned to the assembly.
    type: File?
    inputBinding:
      prefix: --jumps
  unpaired:
    label: bam file of unpaired ngs reads aligned to the assembly.
    type: File?
    inputBinding:
      prefix: --unpaired
  record_changes:
    label: Pilon will create a file listing changes made during polishing.
    type: boolean
    default: True
    inputBinding:
      prefix: --changes
  create_vcf:
    label: pilon will create a vcf file.
    type: boolean
    default: False
    inputBinding:
      prefix: --vcf
  create_tracks:
    label: pilon will write track files suitiable for viewing in a genome browser.
    type: boolean
    default: False
    inputBinding:
      prefix: --tracks
  diploid:
    label: If sample is from diploid organism, this will affect calling of heterozygous SNPs.
    type: boolean
    default: False
    inputBinding:
      prefix: --diploid
  worker_threads:
    label: Number of CPU threads used by some of the polishing steps.
    type: int?
    inputBinding:
      prefix: --threads

outputs:
  polished_assembly:
    label: Assembly after polishing with short reads.
    type: File
    outputBinding:
      glob: $((inputs.assembly.nameroot)+"_pilon_polished.fasta")
  output_directory:
    label: Directory containing all pilon output.
    type: Directory
    outputBinding:
      glob: .

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
