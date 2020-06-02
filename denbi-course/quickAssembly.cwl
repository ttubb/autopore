#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow

hints:
  SoftwareRequirement:
    packages:
      minimap2:
        specs: [ https://github.com/lh3/minimap2 ]
        version: [ "2.16" ]
      miniasm:
        specs: [ https://biosphere.france-bioinformatique.fr/wikia2/index.php/Miniasm
                 https://github.com/lh3/miniasm ]
        version: [ "0.3" ]
      racon:
        specs: [ https://github.com/isovic/racon ]
        version: [ "1.3.2" ]
      samtools:
        specs: [ "https://identifiers.org/RRID:SCR_002105" ]
        version: [ "1.9" ]
      medaka:
        specs: [ "https://github.com/nanoporetech/medaka" ]
        version: [ "0.8.2" ]

requirements:
  SubworkflowFeatureRequirement: {}
  
inputs:
  reads:
    label: File containing reads to build the assembly from.
    type: File
  worker_threads:
    label: Number of CPU-threads used in computationally intensive steps.
    type: int
  assembly_unitig_threshold:
    label: During miniasm assembly, unitigs comprising less reads will be discarded.
    type: int
    default: 4
  assembly_overlap_removal_rounds:
    label: Number of rounds of short overlap removal miniasm will perform.
    type: int
    default: 3
  basecalling_model:
    label: Basecalling model that was used by guppy to basecall reads.
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
  reference_genome:
    label: File containing reference genome, used only for quast report.
    type: File?

outputs:
  draft_assembly:
    type: File
    outputSource: assembling/assembly
  polished_assembly:
    type: File
    outputSource: polishing/polished_assembly
  qc_report:
    type: Directory
    outputSource: qc/report_directory

steps:
  assembling:
    run: ../cwl-tools/assembly/miniasmX3Workflow.cwl
    in:
      reads: reads
      worker_threads: worker_threads
      assembly_unitig_threshold: assembly_unitig_threshold
      assembly_overlap_removal_rounds: assembly_overlap_removal_rounds
    out: [assembly, unitigs_layout]
  polishing:
    run: ../cwl-tools/polishing/medakaTool.cwl
    in:
      reads: reads
      worker_threads: worker_threads
      draft_assembly: assembling/assembly
      basecalling_model: basecalling_model
    out: [polished_assembly]
  qc:
    run: ../cwl-tools/qc/quastTool.cwl
    in:
      assembly: polishing/polished_assembly
      worker_threads: worker_threads
      reference_genome: reference_genome
    out: [report_directory]

s:author:
  - class: s:Person
    s:email: mailto:tom.tubb@googlemail.com
    s:name: Tom Tubbesing
s:dateCreated: "2019-09-22"
s:license: "https://spdx.org/licenses/GPL-3.0-or-later.html"

$namespaces:
  s: "http://schema.org/"
  edam: "http://edamontology.org/"
  cwltool: "http://commonwl.org/cwltool#"

$schemas:
  - https://schema.org/version/latest/schema.rdf
  - http://edamontology.org/EDAM_1.18.owl
