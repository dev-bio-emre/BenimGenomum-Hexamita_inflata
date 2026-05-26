#!/bin/bash
# Step 3: Contamination detection and removal
# Identifies contigs with anomalous coverage (>100x)
# Removes Stenotrophomonas contigs identified via BLAST

ASSEMBLY_INFO=~/BenimGenomum-Hexamita_inflata/GenoDiplo/results/Genomics/1_Assembly/2_Assemblers/flye/raw/assembly_info.txt
ASSEMBLY=~/BenimGenomum-Hexamita_inflata/GenoDiplo/hexamita_inflata_assembly.fasta.gz
OUT_DIR=~/biyoinfo/proje1

# Identify suspicious high-coverage contigs
awk '$3 > 100 && $1 !~ /^#/ {print $1}' $ASSEMBLY_INFO \
  > $OUT_DIR/data/suspicious_contigs.txt

# Extract first 300bp for BLAST submission to NCBI
seqkit grep -f $OUT_DIR/data/suspicious_contigs.txt $ASSEMBLY | \
  seqkit subseq -r 1:300 > $OUT_DIR/data/suspicious_300bp.fasta

# After manual BLAST confirmation (9/9 = Stenotrophomonas)
# Remove contaminating contigs
seqkit grep -v -f $OUT_DIR/data/suspicious_contigs.txt $ASSEMBLY \
  > $OUT_DIR/results/hexamita_clean.fasta

# Verify
seqkit stats $OUT_DIR/results/hexamita_clean.fasta
