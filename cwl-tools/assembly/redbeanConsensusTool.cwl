#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: wtpoa-cns
label: Tool wrapper for the redbean (formerly wtdbg2) consensus module

hints:
  DockerRequirement:
    dockerPull: ttubb/redbean:2.5
  SoftwareRequirement:
    packages:
      redbean/wtdbg2:
        specs: [ "https://github.com/ruanjue/wtdbg2" ]
        version: [ "2.5" ]

inputs:
  assembly_layout:
    label: Draft assembly layout produced by redbean/wtdbg2
    type: File
    inputBinding:
      position: 1
      prefix: -i
  worker_threads:
    label: Number of CPU threads used by tool
    type: int
    default: 1
    inputBinding:
      position: 2
      prefix: -t
  node_max_length:
    label: Maximum expeted length of nodes
    type: int?
    default: 500
    inputBinding:
      position: 3
      prefix: -j
  tri_base_match_bonus:
    label: Bonus for tri-base-matches, defaults to 0
    type: int?
    inputBinding:
      position: 3
      prefix: -b
  match_score:
    label: defaults to 2
    type: int?
    inputBinding:
      position: 3
      prefix: -M
  mismatch_score:
    label: defaults to -5
    type: int?
    inputBinding:
      position: 3
      prefix: -X
  insertion_score:
    label: defaults to -2
    type: int?
    inputBinding:
      position: 3
      prefix: -I
  deletion_score:
    label: defaults to -4
    type: int?
    inputBinding:
      position: 3
      prefix: -D
  homopolymer_merge_score:
    label: used in dp-call-cns mode, defaults to -3
    type: float?
    inputBinding:
      position: 3
      prefix: -H

outputs:
  assembly:
    type: stdout

stdout: redbean-assembly.fasta

s:author:
  - class: s:Person
    s:email: mailto:tom.tubb@googlemail.com
    s:name: Tom Tubbesing
s:dateCreated: "2019-10-24"
s:license: "https://spdx.org/licenses/GPL-3.0-or-later.html"

$namespaces:
  s: "http://schema.org/"

$schemas:
  - http://schema.org/docs/schema_org_rdfa.html
