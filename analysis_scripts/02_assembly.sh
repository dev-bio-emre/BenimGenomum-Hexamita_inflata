#!/bin/bash
# Step 2: De novo genome assembly with Flye
# Run via Snakemake — see workflow/Snakefile and config.yaml
# Manual command equivalent:

flye \
  --nano-raw ~/ham_veri/ERR11414357.fastq \
  --genome-size 142m \
  --threads 4 \
  --out-dir results/Genomics/1_Assembly/2_Assemblers/flye/raw

# QUAST quality assessment
quast \
  ~/biyoinfo/proje1/results/hexamita_clean.fasta \
  -r ~/BenimGenomum-Hexamita_inflata/GenoDiplo/referans_spironucleus.fasta \
  -o ~/biyoinfo/proje1/results/quast_referansli \
  --threads 4
