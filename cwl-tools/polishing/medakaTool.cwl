#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: medaka_consensus
label: Uses medaka to polish an assembly constructed from on ONT nanopore reads that have been basecalled by guppy.

hints:
  DockerRequirement:
    dockerPull: ttubb/medaka:release-0.2.0
  SoftwareRequirement:
    packages:
      minimap2:
        specs: [ "https://github.com/lh3/minimap2" ]
        version: [ "2.16" ]
      samtools:
        specs: [ "https://identifiers.org/RRID:SCR_002105" ]
        version: [ "1.9" ]
      medaka:
        specs: [ "https://github.com/nanoporetech/medaka" ]
        version: [ "0.8.2" ]
        
requirements:
  InlineJavascriptRequirement: {}
  InitialWorkDirRequirement:
    listing:
      - entry: "$({ class: 'Directory', listing: [(inputs.reads),(inputs.draft_assembly)] })"
        entryname: "input"
        writable: true

arguments:
  - valueFrom: "output" #Set medaka output directory
    position: 0
    prefix: -o
  - valueFrom: $("input/"+(inputs.reads.basename))
    position: 1
    prefix: -i
  - valueFrom: $("input/"+(inputs.draft_assembly.basename))
    position: 2
    prefix: -d

inputs:
  worker_threads:
    label: Number of CPU threads used by tool.
    type: int
    inputBinding:
      position: 3
      prefix: -t
  reads:
    label: Basecalled ONT nanopore reads in fastq format.
    type: File
  draft_assembly:
    label: Assembly that medaka will try to polish.
    type: File
  basecalling_model:
    label: Basecalling model that was used by guppy.
    doc: |
      Please consult https://github.com/nanoporetech/medaka for detailed information.
      Choice of medaka model depends on how basecalling was performed.
      Available models: r941_trans, r941_flip213, r941_flip235, r941_min_fast, r941_min_high, r941_prom_fast, r941_prom_high
      For basecalling with guppy version >= v3.0.3, select model based on pore name and whether high or fast basecalling was used.
      For flip flop basecalling with v3.03 > guppy version => v2.3.5 select r941_flip235.
      For flip flop basecalling with v2.3.5 > guppy version >= 2.1.3 select r941_flip213.
      For transducer basecaling using Albacore or non-flip-flop guppy basecalling, select r941_trans.
    type: string
    default: r941_min_high
    inputBinding:
      position: 4
      prefix: -m

outputs:
  polished_assembly:
    label: draft_assembly polished by medaka.
    type: File
    outputBinding:
      glob: output/consensus.fasta

s:author:
  - class: s:Person
    s:email: mailto:tom.tubb@googlemail.com
    s:name: Tom Tubbesing
s:dateCreated: "2019-08-09"
s:license: "https://spdx.org/licenses/GPL-3.0-or-later.html"

$namespaces:
  s: "http://schema.org/"
  edam: "http://edamontology.org/"
  cwltool: "http://commonwl.org/cwltool#"

$schemas:
  - https://schema.org/version/latest/schema.rdf
  - http://edamontology.org/EDAM_1.18.owl
