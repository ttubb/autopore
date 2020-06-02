#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: necat_cfgcreator.sh
label: Uses a custom bash script to fill out a necat config file with the inputs provided to this tool.

hints:
  DockerRequirement:
    dockerPull: ttubb/necat:release-0.2.0

requirements:
  InlineJavascriptRequirement: {}
  InitialWorkDirRequirement:
    listing:
      - $(inputs.config)

arguments:
  - valueFrom: $(inputs.config.basename)
    prefix: -c
  - valueFrom: $(inputs.reads_list.basename)
    prefix: -r

inputs:
  config:
    label: Necat config file which will be filled out by script.
    type: File
  reads_list:
    label: Text file with a list of absolute or relative paths to reads in fastq format.
    type: File
  project_name:
    label: Will be written in config file as project name.
    type: string
    inputBinding:
      prefix: -n
  estimated_genome_size:
    label: Estimation of how large (in bases) the analyzed genome is.
    type: int
    inputBinding:
      prefix: -s
  worker_threads:
    label: CPU-threads which will be used by the necat pipeline.
    type: int
    default: 1
    inputBinding:
      prefix: -t

outputs:
  filled_config:
    label: inputs.config with all other input parameters filled in.
    type: File
    outputBinding:
      glob: filled_config.txt

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
