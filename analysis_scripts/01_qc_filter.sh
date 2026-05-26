#!/bin/bash
# Step 1: Quality Control and Filtering of Oxford Nanopore reads
# Input: ERR11414357.fastq (raw Nanopore reads)
# Output: filtered_reads.fastq, NanoPlot QC reports

RAW_READS=~/ham_veri/ERR11414357.fastq
OUT_DIR=~/biyoinfo/proje1/results

# Raw read QC
NanoPlot \
  --fastq $RAW_READS \
  --outdir $OUT_DIR/nanoplot_raw \
  --plots dot \
  -t 4

# Quality filtering
filtlong \
  --min_length 1000 \
  --min_mean_q 10 \
  --keep_percent 90 \
  $RAW_READS \
  > $OUT_DIR/filtered_reads.fastq

# Post-filter QC
NanoPlot \
  --fastq $OUT_DIR/filtered_reads.fastq \
  --outdir $OUT_DIR/nanoplot_filtered \
  --plots dot \
  -t 4
