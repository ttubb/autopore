#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: [deepbinner, bin]
label: Sorts reads by barcode based on the list created by the deepbinner classify command.

hints:
  DockerRequirement:
    dockerPull: ttubb/deepbinner:release-0.2.0
  SoftwareRequirement:
    packages:
      deepbinner:
        specs: [ https://github.com/rrwick/Deepbinner ]
        version: [ 0.2.0 ]

arguments:
  - valueFrom: . #Deepbinners output directory.
    position: 3
    prefix: --out_dir

inputs:
  classifications:
    label: Deepbinner classification file created by classify command.
    type: File
    inputBinding:
      prefix: --classes
      position: 1
  reads:
    label: Reads to demultiplex.
    type: File
    inputBinding:
      prefix: --reads
      position: 2

outputs:
  zipped_reads_by_barcode_array:
    label: Array of reads in gz-format, with each array entry pertaining to a specific barcode.
    type: File[]
    outputBinding:
      glob: "barcode*.gz"
  zipped_reads_unclassified:
    label: Reads which could not be matched to a barcode.
    type: File
    outputBinding:
      glob: "unclassified*"
  demultiplexing_summary:
    label: Text file listing how many reads were matched to each barcode.
    type: stdout

stdout: demultiplexing_summary.txt

s:author:
  - class: s:Person
    s:email: mailto:tom.tubb@googlemail.com
    s:name: Tom Tubbesing
s:dateCreated: "2019-02-15"
s:license: https://spdx.org/licenses/GPL-3.0-or-later

$namespaces:
  s: http://schema.org/
  edam: http://edamontology.org/

$schemas:
  - http://schema.org/docs/schema_org_rdfa.html
  - http://edamontology.org/EDAM_1.20.owl
