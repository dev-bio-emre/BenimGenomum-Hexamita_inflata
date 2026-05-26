#!/bin/bash
# Step 4: Structural and functional annotation
# Uses alternative genetic code 6 for diplomonads

CLEAN_ASSEMBLY=~/biyoinfo/proje1/results/hexamita_clean.fasta
OUT_DIR=~/biyoinfo/proje1/results

# Structural annotation with Prodigal (metagenome mode, genetic code 6)
mkdir -p $OUT_DIR/prodigal
prodigal \
  -i $CLEAN_ASSEMBLY \
  -o $OUT_DIR/prodigal/hexamita.gff \
  -a $OUT_DIR/prodigal/hexamita.faa \
  -f gff \
  -g 6 \
  -p meta

# Filter proteins shorter than 100 aa
seqkit seq \
  --min-len 100 \
  $OUT_DIR/prodigal/hexamita.faa \
  > $OUT_DIR/prodigal/hexamita_filtered.faa

# Build Diamond database from SwissProt
diamond makedb \
  --in ~/biyoinfo/proje1/data/uniprot_sprot.fasta.gz \
  --db ~/biyoinfo/proje1/data/swissprot \
  --threads 4

# Functional annotation
mkdir -p $OUT_DIR/diamond
diamond blastp \
  --query $OUT_DIR/prodigal/hexamita_filtered.faa \
  --db ~/biyoinfo/proje1/data/swissprot \
  --out $OUT_DIR/diamond/hexamita_vs_swissprot.tsv \
  --outfmt 6 qseqid sseqid pident length evalue bitscore stitle \
  --evalue 1e-5 \
  --threads 4 \
  --max-target-seqs 1

# Identify Cathepsin B homologs
grep "Cathepsin" $OUT_DIR/diamond/hexamita_vs_swissprot.tsv
