#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow
label: Performs demultiplexing of barcoded nanopore read data based on the raw fast5 files.
doc: |
  Deepbinner employs a convolutional neural network to match reads with barcodes based on the raw nanopore signal data. The first step of the workflow will translate the barcoding kit names used by oxford nanopore to indicate to deepbinner whether native or rapid barcoding was performed.

hints:
  cwltool:LoadListingRequirement:
    loadListing: shallow_listing
  SoftwareRequirement:
    packages:
      deepbinner:
        specs: [ https://github.com/rrwick/Deepbinner ]
        version: [ "0.2.0" ]
  
requirements:
  ScatterFeatureRequirement: {}
  InlineJavascriptRequirement: {}

inputs:
  worker_threads:
    label: Number of CPU-threads used in computationally intensive stepss.
    type: int?
    default: 1
  reads:
    label: fastq file containing basecalled nanopore reads.
    type: File
  fast5_directory:
    label: Firectory containing raw nanopore signal data in fast5 format
    type: Directory
  kit_id:
    label: Identifier of kit used in nanopore experiment (e.g. SQK-RBK004)
    type: string

outputs:
  reads_by_barcode_array:
    label: Array of reads with each array entry pertaining to a specific barcode.
    type: File[]
    outputSource: decompress_barcoded/unzipped_file
  unclassified_reads:
    label: Reads which could not be matched to a barcode.
    type: ["null",File]
    outputSource: decompress_unclassified/unzipped_file
  demultiplexing_summary:
    label: Text file listing how many reads were matched to each barcode.
    type: File
    outputSource: binning/demultiplexing_summary

steps:
  detect_bc_type:
    label: Use a kit id provided in the guppy-format (e.g. SQK-RBK004) to determine whether native or rapid barcoding was used.
    run:
      class: ExpressionTool
      inputs:
        kit_id:
          type: string
      outputs:
        barcoding_type:
          type: string
      expression: |
        ${
          //Decide whether rapid or native barcoding was used
          var bctype;
          var kitname = inputs.kit_id;
          //The fifth character, at index 4, is enough to differentiate rapid from native kits.
          var idchar  = kitname.charAt(4);
          if ( idchar == "R" )
          {
            bctype = "--rapid";
          } else {
            bctype = "--native";
          }
          return {barcoding_type: bctype}
        }
    in:
      kit_id: kit_id
    out: [barcoding_type]
  classification:
    label: Classify all raw reads.
    run: deepbinnerClassifyTool.cwl
    in:
      barcoding_type: detect_bc_type/barcoding_type
      fast5_directory: fast5_directory
      worker_threads: worker_threads
    out: [classifications]
  binning:
    label: Sort basecalled reads according to the classifications of their raw counterparts.
    run: deepbinnerBinTool.cwl
    in:
      classifications: classification/classifications
      reads: reads
    out: [zipped_reads_by_barcode_array, zipped_reads_unclassified, demultiplexing_summary]
  decompress_barcoded:
    label: Decompress gzipped files with barcoded reads.
    run: ../misc/gzipDecompressTool.cwl
    scatter: zipped_file
    in:
      zipped_file: binning/zipped_reads_by_barcode_array
    out: [unzipped_file]
  decompress_unclassified:
    label: Decompress gzipped files with unclassified reads.
    run: ../misc/gzipDecompressTool.cwl
    in:
      zipped_file: binning/zipped_reads_unclassified
    out: [unzipped_file]

s:author:
  - class: s:Person
    s:email: mailto:tom.tubb@googlemail.com
    s:name: Tom Tubbesing
s:dateCreated: "2019-02-15"
s:license: https://spdx.org/licenses/GPL-3.0-or-later

$namespaces:
  s: "http://schema.org/"
  edam: "http://edamontology.org/"
  cwltool: "http://commonwl.org/cwltool#"
  
$schemas:
  - https://schema.org/version/latest/schema.rdf
  - http://edamontology.org/EDAM_1.20.owl
