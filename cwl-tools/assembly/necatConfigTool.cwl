#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: [necat.pl, config]
label: Uses necat to create a template config file for the necat assembler.

hints:
  SoftwareRequirement:
    packages:
      necat:
        specs: [ "https://github.com/xiaochuanle/NECAT" ]
        version: [ "0.01" ]
    
requirements:
  DockerRequirement:
    dockerPull: ttubb/necat:release-0.2.0
  InlineJavascriptRequirement: {}

inputs:
  configname:
    label: Name of the config file necat will generate.
    type: string
    inputBinding:
      position: 1
      
outputs:
  necat_config:
    label: Incomplete config file where several fields still have to be filled in, named after inputs.configname.
    type: File
    outputBinding:
      glob: $(inputs.configname)

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

