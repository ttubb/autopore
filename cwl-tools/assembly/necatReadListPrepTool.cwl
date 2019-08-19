#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: necat_readlister.sh
label: Creates a list of all reads in the input fastq file using a custom bash script.

hints:
  DockerRequirement:
    dockerPull: ttubb/necat:release-0.2.0
        
requirements:
  InlineJavascriptRequirement: {}
    
arguments:
  - valueFrom: $(inputs.reads.basename)
    position: 1

inputs:
  reads:
    label: fastq file containing basecalled ONT nanopore reads..
    type: File

outputs:
  reads_list:
    label: Text file containing the name if inputs.reads.
    type: File
    outputBinding:
      glob: reads_list.txt

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
  - http://schema.org/docs/schema_org_rdfa.html
  - http://edamontology.org/EDAM_1.18.owl

