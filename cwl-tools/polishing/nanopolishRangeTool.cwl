#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: nanopolish_makerange.py
label: Generates information on how to split a draft genome for nanopolish.

hints:
  DockerRequirement:
    dockerPull: ttubb/nanopolish:0.11.2
  SoftwareRequirement:
    packages:
      nanopolish:
        specs: [ https://identifiers.org/rrid/RRID:SCR_016157 ]
        version: [ "0.11.2" ]
        
requirements:
  InlineJavascriptRequirement: {}
  InitialWorkDirRequirement:
    listing: [ $(inputs.draft_genome) ]

inputs:
  draft_genome:
    label: Draft genome created by assembler.
    type: File
    inputBinding:
      position: 1

outputs:
  contig_windows:
    label: Information on how to split contigs before processing.
    type: stdout

stdout: contig_windows.txt
    
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
  - https://schema.org/version/latest/schema.rdf
  - http://edamontology.org/EDAM_1.18.owl
