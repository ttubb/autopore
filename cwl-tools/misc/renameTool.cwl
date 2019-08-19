#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: mv
label: Takes an input file, changes the filename according to the newname parameter and returns the renamed file.

requirements:
  InitialWorkDirRequirement:
    listing:
      - entry: $(inputs.rename_this)
        writable: true

hints:
  DockerRequirement:
    dockerPull: busybox

inputs:
  namesource:
    label: Will never be used directly by this tool. Listed to allow passing this files name as newname in a parent workflow by using StepInputExpressionRequirement.
    type: [File?, Directory?]
  newname:
    label: Name which will be given to rename_this.
    type: string
    inputBinding:
      position: 2
  rename_this:
    label: File or directory which will have its name changed.
    type: [File, Directory]
    inputBinding:
      position: 1

outputs:
  file_renamed:
    label: Renamed version of input file or directory.
    type: [File, Directory]
    outputBinding:
      glob: $(inputs.newname)

s:author:
  - class: s:Person
    s:email: mailto:tom.tubb@googlemail.com
    s:name: Tom Tubbesing
s:dateCreated: "2019-05-09"
s:license: https://spdx.org/licenses/GPL-3.0-or-later

$namespaces:
  s: http://schema.org/

$schemas:
  - http://schema.org/docs/schema_org_rdfa.html
