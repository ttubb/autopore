#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: NanoPlot
label: Uses NanoPlot to generate a quality control report based on fastq reads.

hints:
  DockerRequirement:
    dockerPull: ttubb/nanoplot:release-0.2.0
  SoftwareRequirement:
    packages:
      nanoplot:
        specs: [ https://github.com/wdecoster/NanoPlot ]
        version: [ "1.22.0" ]
        
requirements:
  InlineJavascriptRequirement: {}

arguments:
  - valueFrom: nanoplot-report #Output directory
    prefix: --outdir
    position: 0
  - valueFrom: |
      ${
        //If no read_format was specified, use the file extension of inputs.reads
        if ( inputs.reads_format == undefined ) {
          var nameextArray = (inputs.reads.nameext).split(".");
          var format = nameextArray[(nameextArray.length)-1];
          return format;
        }
        //Otherwise, use the read_format that was specified.
        var format = inputs.reads_format;
        return format;
      }
    prefix: --
    separate: false
    position: 2

inputs:
  reads:
    label: Basecalled nanopore reads in fastq format.
    type: File
    inputBinding:
      position: 3
  reads_format:
    label: File format of input reads. If not specified, tool will try to infer the format from the nameext of the reads file.
    type: string?
  worker_threads:
    label: Number of CPU-threads used by tool.
    type: int?
    inputBinding:
      prefix: --threads
      position: 1

outputs: 
  report_directory:
    type: Directory
    label: Directory containing all nanoplot report data.
    outputBinding:
      glob: ./nanoplot-report

s:author:
  - class: s:Person
    s:email: mailto:tom.tubb@googlemail.com
    s:name: Tom Tubbesing
s:dateCreated: "2019-05-16"
s:license: "https://spdx.org/licenses/GPL-3.0-or-later.html"

$namespaces:
  s: http://schema.org/
  edam: http://edamontology.org/

$schemas:
  - http://schema.org/docs/schema_org_rdfa.html
  - http://edamontology.org/EDAM_1.20.owl
