#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow
label: Uses nanopolish to polish a draft genome assembly using the raw nanopore signal data.

hints:
  cwltool:LoadListingRequirement:
    loadListing: shallow_listing
  SoftwareRequirement:
    packages:
      nanopolish:
        specs: [ https://identifiers.org/rrid/RRID:SCR_016157 ]
        version: [ "0.11.2" ]
      graphmap:
        specs: [ https://anaconda.org/bioconda/graphmap ]
        version: [ "0.3.0" ]

requirements:
  InlineJavascriptRequirement: {}
  ScatterFeatureRequirement: {}

inputs:
  worker_threads:
    label: Number of CPU-threads used for computationally intensive steps.
    type: int
  draft_genome:
    label: Draft genome created by assembler.
    type: File
  fast5_directory:
    label: Directory containing raw nanopore signal data in fast5 format.
    type: Directory
  reads:
    label: Basecalled ONT nanopore reads in fastq format.
    type: File

outputs:
  polished_assembly:
    label: Polished version of draft_genome.
    type: ["null",File]
    outputSource: np_merging/polished_genome
  
steps:  
  mapping:
    label: Map reads to draft assembly.
    run: ../mapping/graphmapTool.cwl
    in:
      worker_threads: worker_threads
      reference_genome: draft_genome
      reads: reads
    out: [alignment_map]    
  sam_sorting:
    label: Sort alignment map.
    run: ../misc/samtoolsSortTool.cwl
    in:
      worker_threads: worker_threads
      alignment: mapping/alignment_map
    out: [sorted_alignment]    
  sam_indexing:
    label: Create index for alignment map.
    run: ../misc/samtoolsIndexTool.cwl
    in:
      worker_threads: worker_threads
      bamfile: sam_sorting/sorted_alignment
    out: [index]    
  np_indexing:
    label: Create read index.
    run: nanopolishIndexTool.cwl
    in:
      fast5_directory: fast5_directory
      reads: reads
    out: [reads_with_index]
  np_rangemaking:
    label: Split draft genome into windows.
    run: nanopolishRangeTool.cwl
    in:
      draft_genome: draft_genome
    out: [contig_windows]
  np_polishing:
    label: Polish draft genome window.
    run: nanopolishVariantsTool.cwl
    scatter: contig_window
    in:
      worker_threads: worker_threads
      reads_with_index: np_indexing/reads_with_index
      alignment_map: sam_sorting/sorted_alignment
      alignment_map_index: sam_indexing/index
      draft_genome: draft_genome
      contig_window: rangesplitting/window_array
    out: [variant_calls]
  rangesplitting:
    label: Extract individual windows from list of contig windows.
    run:
      class: ExpressionTool
      inputs:
        contig_windows:
          type: File
          inputBinding:
            loadContents: true
      outputs:
        window_array:
          type: string[]
      expression: >
        ${
          var lines = inputs.contig_windows.contents.split('\n');
          lines.pop();
          return { 'window_array' : lines }
        }
    in:
      contig_windows: np_rangemaking/contig_windows
    out: [window_array]
  np_merging:
    label: Merge all polished windows together.
    run: nanopolishMergeTool.cwl
    in:
      draft_genome: draft_genome
      vcalls: np_polishing/variant_calls
    out: [polished_genome]

s:author:
  - class: s:Person
    s:email: mailto:tom.tubb@googlemail.com
    s:name: Tom Tubbesing
s:dateCreated: "2019-02-11"
s:license: "https://spdx.org/licenses/GPL-3.0-or-later.html"

$namespaces:
  s: "http://schema.org/"
  edam: "http://edamontology.org/"
  cwltool: "http://commonwl.org/cwltool#"

$schemas:
  - https://schema.org/version/latest/schema.rdf
  - http://edamontology.org/EDAM_1.18.owl
