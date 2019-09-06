class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  s: 'http://schema.org/'
baseCommand:
  - porechop
inputs:
  output_format:
    type:
      - 'null'
      - type: enum
        symbols:
          - auto
          - fasta
          - fastq
          - fasta.gz
          - fastq.gz
        name: output_format
    inputBinding:
      position: 0
      prefix: '--format'
    label: >-
      Output format for reads. Has to be one of
      (auto,fasta,fastq,fasta.gz,fastq.gz). If not set, format will be chosen
      based format of input reads.
  reads:
    type:
      - File
      - Directory
    inputBinding:
      position: 0
      prefix: '--input'
    label: Reads with adapters.
  worker_threads:
    type: int?
    inputBinding:
      position: 0
      prefix: '--threads'
    label: Number of CPU-threads used by tool.
  verbosity:
    type:
      - 'null'
      - type: enum
        symbols:
          - '0'
          - '1'
          - '2'
          - '3'
        name: verbositiy
    default: '1'
    inputBinding:
      position: 0
      prefix: '--verbosity'
    label: Level of progress information
  output:
    type:
      - type: record
        name: output_file
        fields:
          output_file:
            type: string
            inputBinding:
              position: 0
              prefix: '--output'
            label: Filename for output of trimmed reads
      - type: record
        name: output_directory
        fields:
          output_directory:
            type: string
            inputBinding:
              position: 0
              prefix: '--barcode_dir'
          barcode_threshold:
            type: float?
            label: "A read must have at least percent identity to a barcode to be binned"
            inputBinding:
              position: 0
              prefix: '--barcode_threshold'
          barcode_diff:
            type: float?
            label: >-
              If the difference between a read's best barcode identity and its second-best barcode identity is less than
              this value it will not be put in a barcode bin.
            inputBinding:
              position: 0
              prefix: '--barcode_diff'
          require_two_barcodes:
            type: boolean?
            label: "Reads will only be put in a barcode bin if they have a strong match for the barcode on both their start and end"
            inputBinding:
              position: 0
              prefix: '--require_two_barcodes'
          untrimmed:
            type: boolean?
            label: "Bin reads but do not trim"
            inputBinding:
              position: 0
              prefix: '--untrimmed'
          discard_unassigned:
            type: boolean?
            label: "Discard unassigned reads (instead of creating a 'none' bin)"
            inputBinding:
              position: 0
              prefix: "--discard_unassigned"
  adapter_threshold:
    type: float?
    label: >-
      An adapter set has to have at least this percent identity to be
      labelled as present and trimmed off (0 to 100)
    default: 90
    inputBinding:
      position: 0
      prefix: "--adapter_threshold"
  check_reads:
    type: int?
    label: >-
      This many reads will be aligned to all possible adapters to
      determine which adapter sets are present
    inputBinding:
      position: 0
      prefix: "--check_reads"
    default: 10000
  scoring_scheme:
    type: string?
    label: >-
      Comma-delimited string of alignment scores: match, mismatch, gap
      open, gap extend
    default: "3,-6,-5,-2"
  end_size:
    type: int?
    label: "The number of base pairs at each end of the read which will be searched for adapter sequences"
    default: 150
    inputBinding:
      position: 0
      prefix: "--end_size"
  minimum_trim_size:
    type: int?
    label: "Adapters smaller than this will be ignored"
    default: 4
    inputBinding:
      position: 0
      prefix: "--min_trim_size"
  extra_end_trim:
    type: int?
    label: "This many additional bases will be removed next to adapters found at the ends of reads"
    default: 2
    inputBinding:
      position: 0
      prefix: "--extra_end_trim"
  end_threshold:
    type: float?
    label: "Adapters at the ends of reads must have at least this percent identity to be removed"
    default: 75.0
    inputBinding:
      position: 0
      prefix: "--end_threshold"
  no_split:
    type: boolean?
    label: "Skip splitting reads based on middle adapters"
    inputBinding:
      position: 0
      prefix: "--no_split"
  discard_middle:
    type: boolean?
    label: >-
      Reads with middle adapters will be discarded (required for reads to be used with
      Nanopolish, this option is on by default when outputting reads into barcode bins)
    inputBinding:
      position: 0
      prefix: "--discard_middle"
  middle_threshold:
    type: float?
    label: "Adapters in the middle of reads must have at least this percent identity to be found"
    default: 85.0
    inputBinding:
      position: 0
      prefix: "--middle_threshold"
  extra_middle_trim_good_side:
    type: int?
    label: "This many additional bases will be removed next to middle adapters on their 'good' side"
    default: 10
    inputBinding:
      position: 0
      prefix: "--extra_middle_trim_good_side"
  extra_middle_trim_bad_side:
    type: int?
    label: "This many additional bases will be removed next to middle adapters on their 'bad' side"
    default: 100
    inputBinding:
      position: 0
      prefix: "--extra_middle_trim_bad_side"
  minimum_split_read_size:
    type: int?
    label: "Post-split read pieces smaller than this many base pairs will not be outputted"
    default: 1000
    inputBinding:
      position: 0
      prefix: "--min_split_read_size"
  
outputs:
  trimmed_reads:
    label: >-
      Trimmed version of reads in same file format (or format specified by
      output_format). Only output if barcode binning is not specified 
      (i.e. output_file mode)
    type: File?
    outputBinding:
      glob: $(inputs.output.output_file || [])
  split_reads:
    label: >-
      Directory containing barcoded reads, split into barcode bins (only output if output is 
      using output_directory, i.e. binning, mode)
    type: Directory?
    outputBinding:
      glob: $(inputs.output.output_directory || [])
  logfile:
    label: Porechop log file 
    type: stdout
stdout: $(inputs.reads.basename).porechop.log

label: >-
  Porechop is a tool for finding and removing adapters from Oxford Nanopore reads. Adapters on the ends of reads are trimmed off,
  and when a read has an adapter in its middle, it is treated as chimeric and chopped into separate reads. Porechop performs thorough
  alignments to effectively find adapters, even at low sequence identity.
   
  Porechop also supports demultiplexing of Nanopore reads that were barcoded with the Native Barcoding Kit, PCR Barcoding Kit
  or Rapid Barcoding Kit.
hints:
  - class: SoftwareRequirement
    packages:
      porechop:
        specs:
          - 'https://identifiers.org/RRID:SCR_016967'
        version:
          - 0.2.4
  - class: DockerRequirement
    dockerPull: ttubb/porechop
requirements:
  - class: InlineJavascriptRequirement
$schemas:
  - 'http://schema.org/docs/schema_org_rdfa.html'
's:author':
  - class: 's:Person'
    's:email': 'mailto:tom.tubb@googlemail.com'
    's:name': Tom Tubbesing
's:dateCreated': '2019-05-18'
's:license': 'https://spdx.org/licenses/GPL-3.0-or-later'
