#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: racon
label: Polishes raw contigs where the assembly method did not include a consensus step. Can also be used to polish a long read draft assembly with short reads.
doc: |
  Polishes raw contigs where the assembly method did not include a consensus step. Might also be used to polish a other assemblies with an additional set of reads (e.g. polish a canu nanopore assembly with illumina reads).
  
hints:
  DockerRequirement:
    dockerPull: ttubb/racon:1.4.3
  SoftwareRequirement:
    packages:
      racon:
        specs: [ https://github.com/isovic/racon ]
        version: [ 1.3.2 ]

requirements:
  InlineJavascriptRequirement: {}

inputs:
  sequences:
    label: Input file in FASTA/FASTQ format (can be compressed with gzip) containing sequences used for correction.
    type: File
    inputBinding:
      position: 1
  overlaps:
    label: Input file in MHAP/PAF/SAM format (can be compressed with gzip) containing overlaps between sequences and target sequences.
    type: File
    inputBinding:
      position: 2
  target_sequences:
    label: Input file in FASTA/FASTQ format (can be compressed with gzip) containing sequences which will be corrected.
    type: File
    inputBinding:
      position: 3
  window_length:
    label: Size of window on which POA is performed (default is 500).
    type: int?
    inputBinding:
      prefix: --window-length
      position: 0
  quality_threshold:
    label: Threshold for average base quality of windows used in POA (Default is 10.0).
    type: float?
    inputBinding:
      prefix: --quality-threshold
      position: 0
  error_threshold:
    label: Maximum allowed error rate used for filtering overlaps (default is 0.3).
    type: float?
    inputBinding:
      prefix: --error-threshold
      position: 0
  match_score:
    label: Score for matching bases (default is 5).
    type: int?
    inputBinding:
      prefix: --match
      position: 0
  mismatch_score:
    label: Score for mismatching bases (default is -4).
    type: int?
    inputBinding:
      prefix: --mismatch
      position: 0
  gap_penalty:
    label: Gap penalty (must be negative, default is -8).
    type: int?
    inputBinding:
      prefix: --gap
      position: 0
  worker_threads:
    label: Number of CPU-threads used by racon (default is 1).
    type: int?
    inputBinding:
      prefix: --threads
      position: 0

outputs:
  polished_assembly:
    label: Polished version of input sequences.
    type: stdout

stdout: $(inputs.sequences.nameroot+"_consensus_assembly.fasta")

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
