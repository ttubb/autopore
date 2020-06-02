#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow
label: Creates a de novo assembly from basecalled long ONT nanopore reads.
doc: |
  This workflow creates a denovo assembly from basecalled, long ONT nanpore reads. It then polishes the assembly and provides the draft assembly and the polished assembly as results.

hints:
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
      necat:
        specs: [ "https://github.com/xiaochuanle/NECAT" ]
        version: [ "0.01" ]

requirements:
  SubworkflowFeatureRequirement: {}
  InlineJavascriptRequirement: {}
  StepInputExpressionRequirement: {}

inputs:
  worker_threads:
    label: Number of CPU-threads used in computationally intensive steps.
    type: int
  reads:
    label: Basecalled ONT nanopore reads in a fastq file.
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
  estimated_genome_size:
    label: Size estimate (in bp) for the genome that was sequenced.
    type: int

outputs:
  draft_assembly:
    type: File
    outputSource: rename_draft_assembly/file_renamed
  polished_assembly:
    type: File
    outputSource: rename_polished_assembly/file_renamed
    
steps:
  assembling:
    label: Uses necat to create draft assembly from reads. 
    run: ../cwl-tools/assembly/necatWorkflow.cwl
    in:
      worker_threads: worker_threads
      reads: reads
      estimated_genome_size: estimated_genome_size
    out: [contigs]      
  polishing:
    label: Uses medaka to polish draft assembly.
    run: ../cwl-tools/polishing/medakaTool.cwl
    in:
      worker_threads: worker_threads
      reads: reads
      draft_assembly: assembling/contigs
      basecalling_model: basecalling_model
    out: [polished_assembly]
  rename_draft_assembly:
    label: Change name of draft assembly file.
    run: ../cwl-tools/misc/renameTool.cwl
    in:
      rename_this: assembling/contigs
      namesource: reads
      newname:
        valueFrom: $((inputs.namesource.nameroot)+"_draft_assembly.fasta")
    out: [file_renamed]
  rename_polished_assembly:
    label: Change name of polished assembly file.
    run: ../cwl-tools/misc/renameTool.cwl
    in:
      rename_this: polishing/polished_assembly
      namesource: reads
      newname:
        valueFrom: $((inputs.namesource.nameroot)+"_polished_assembly.fasta")
    out: [file_renamed]
  
s:author:
  - class: s:Person
    s:email: mailto:tom.tubb@googlemail.com
    s:name: Tom Tubbesing
s:dateCreated: "2019-04-11"
s:license: "https://spdx.org/licenses/GPL-3.0-or-later.html"

$namespaces:
  s: "http://schema.org/"
  edam: "http://edamontology.org/"
  cwltool: "http://commonwl.org/cwltool#"

$schemas:
  - https://schema.org/version/latest/schema.rdf
  - http://edamontology.org/EDAM_1.18.owl
