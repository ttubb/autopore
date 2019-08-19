#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: multi_to_single_fast5
label: Splits all multi-read fast5 files in the input folder into single-read fast5 files and places them in the output folder. Output files will be named after the reads they contain.

hints:
  cwltool:LoadListingRequirement:
    loadListing: shallow_listing
  DockerRequirement:
    dockerPull: ttubb/ont-fast5-api:release-0.2.0
  SoftwareRequirement:
    packages:
      ont-fast5-api:
        specs: [ https://pypi.org/project/ont-fast5-api/
                 https://github.com/nanoporetech/ont_fast5_api ]
        version: [ 1.3.0 ]
      
arguments:
  - valueFrom: "single_read_fast5s" #Output directory
    prefix: --save_path

inputs:
  fast5_dir:
    label: Folder containing single-read fast5 files.
    type: Directory
    inputBinding:
      prefix: --input_path
  worker_threads:
    label: CPU threads used by tool.
    type: int
    default: 1
    inputBinding:
      prefix: --threads
  recursive:
    label: Recursively search subdirectories of fast5_folder.
    type: boolean
    default: true
    inputBinding:
      prefix: --recursive

outputs:
  split_fast5_dir:
    label: Folder containing the single-read fast5 files.
    type: Directory
    outputBinding:
      glob: "single_read_fast5s"

s:author:
  - class: s:Person
    s:email: mailto:tom.tubb@googlemail.com
    s:name: Tom Tubbesing
s:dateCreated: "2019-05-09"
s:license: "https://spdx.org/licenses/GPL-3.0-or-later.html"

$namespaces:
  s: "http://schema.org/"
  edam: "http://edamontology.org/"
  cwltool: "http://commonwl.org/cwltool#"

$schemas:
  - http://schema.org/docs/schema_org_rdfa.html
