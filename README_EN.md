# Hexamita inflata Drug Discovery Pipeline 🧬💊

*From Oxford Nanopore Sequencing to Computational Drug Target Identification*

A complete bioinformatics pipeline for the diplomonad parasite **Hexamita inflata** — spanning from raw sequencing data to drug candidate discovery. Includes de novo genome assembly, decontamination, functional annotation, AlphaFold structure prediction, and molecular docking.

> 🇹🇷 [Türkçe versiyon için tıklayın](README.md)

---

## 🎯 Project Overview

```
Raw Data (Oxford Nanopore)
       ↓
1. Quality control & filtering (NanoPlot, Filtlong)
       ↓
2. De novo assembly (Flye)
       ↓
3. Contamination detection & removal (BLAST, SeqKit)
       ↓
4. Structural & functional annotation (Prodigal, Diamond)
       ↓
5. Drug target selection (Cathepsin B)
       ↓
6. Protein structure prediction (AlphaFold2, pLDDT: 93.69)
       ↓
7. Binding pocket analysis (fpocket)
       ↓
8. Virtual screening & molecular docking (AutoDock Vina)
       ↓
9. Protein-ligand interaction analysis (PLIP, PyMOL)
       ↓
🏆 Drug candidate: Balicatib (-7.027 kcal/mol)
```

---

## 🏆 Key Finding

**Balicatib**, a known Cathepsin K inhibitor, exhibited the highest binding affinity against *Hexamita inflata* Cathepsin B at **-7.027 kcal/mol** — outperforming 6 other reference inhibitors.

Key interactions:
- **TYR137** parallel π-stacking (4.28 Å) — strongest
- **PHE56** T-shaped π-stacking (5.11 Å)
- **ASP126** hydrogen bond (4.08 Å)

---

## 🛠️ Tools Used

| Stage | Tool |
|---|---|
| Workflow management | Snakemake |
| Raw data QC | NanoPlot, FastQC |
| Filtering | Filtlong |
| Genome assembler | Flye |
| Assembly QC | QUAST, MultiQC |
| Alignment | Winnowmap, Meryl |
| Contamination detection | BLAST (NCBI), SeqKit |
| Gene prediction | Prodigal |
| Functional annotation | Diamond BLASTP, SwissProt |
| Protein structure prediction | AlphaFold2 (EBI) |
| Binding pocket | fpocket |
| Molecular docking | AutoDock Vina |
| Format conversion | OpenBabel |
| Interaction analysis | PLIP |
| Visualization | PyMOL Open-Source |

---

## 📊 Raw Data Characteristics (ERR11414357)

| Metric | Value |
|---|---|
| Sequencing technology | Oxford Nanopore (Long-Read) |
| Total reads | 500,433 |
| Total bases | ~4.7 Gb |
| Mean read length | 9,471 bp |
| Read length N50 | 18,889 bp |
| Longest read | 152,097 bp |
| Mean quality | Q9.6 |

---

## 🔬 Pipeline Steps

### 1. Quality Control and Filtering

Raw data assessment with NanoPlot, followed by Filtlong to remove low-quality and short reads.

| Metric | Raw | Filtered |
|---|---|---|
| Read count | 500,433 | 345,059 |
| Mean length | 9,471 bp | 12,362 bp |
| Mean quality | Q9.6 | Q10.2 |
| Total bases | 4.7 Gb | 4.3 Gb |
| Estimated coverage | 30x | 27.7x |

📄 Script: [`analysis_scripts/01_qc_filter.sh`](analysis_scripts/01_qc_filter.sh)

### 2. De Novo Genome Assembly

Long-read assembly using Flye assembler.

| Metric | Value |
|---|---|
| Total size | 154.1 Mb |
| Contig count | 1,243 |
| Largest contig | 3,266,783 bp |
| N50 | 324,714 bp |
| L50 | 110 |
| Misassemblies | 0 |
| GC content | 34.57% |

📄 Script: [`analysis_scripts/02_assembly.sh`](analysis_scripts/02_assembly.sh)

### 3. Contamination Detection and Decontamination ⚠️

Coverage anomaly analysis revealed **9 Stenotrophomonas spp. contigs** (totaling 4.9 Mb, 3.1% of raw assembly).

| Metric | Raw | Clean |
|---|---|---|
| Contig count | 1,243 | 1,234 |
| Total size | 154.1 Mb | 149.3 Mb |
| GC content | 34.57% | 33.53% |

📄 Script: [`analysis_scripts/03_decontamination.sh`](analysis_scripts/03_decontamination.sh)
📋 Table: [`tables/Table1_contamination.csv`](tables/Table1_contamination.csv)

### 4. Structural and Functional Annotation

Prodigal (genetic code 6 for diplomonad alternative code) predicted 27,312 proteins; Diamond BLASTP annotated 2,691 proteins functionally.

Top matching organisms:
- *Arabidopsis thaliana* (n=281)
- *Dictyostelium discoideum* (n=216)
- *Giardia intestinalis* (n=162) ← evolutionary proximity confirmed

📄 Script: [`analysis_scripts/04_annotation.sh`](analysis_scripts/04_annotation.sh)

### 5. Drug Target Selection: Cathepsin B

Cathepsin B-like cysteine protease — a known virulence factor in diplomonad parasites — was selected as the drug target. Top candidate: `contig_1287_94` (49.4% identity, E-value: 4.15e-81 vs Giardia CP3).

### 6. Protein Structure Prediction (AlphaFold2)

UniProt: **A0AA86UFS0**
- 287 amino acids
- **pLDDT: 93.69** (very high confidence)
- First structural model (no experimental structure in PDB)

🔗 [AlphaFold page](https://alphafold.ebi.ac.uk/entry/A0AA86UFS0)

### 7. Binding Pocket Analysis

fpocket v4.0 identified 16 pockets. Top-scored pocket:
- Druggability score: **0.77**
- Volume: 846 Å³
- Contains Cys and His → catalytic triad ✅

### 8. Virtual Screening and Molecular Docking

Seven known cysteine protease inhibitors screened with AutoDock Vina.

| Compound | PubChem CID | Binding Affinity (kcal/mol) |
|---|---|---|
| **Balicatib** ⭐ | 44450571 | **-7.027** |
| Odanacatib | 5347510 | -6.339 |
| E-64 | 9576072 | -6.048 |
| Leupeptin | 5311272 | -5.977 |
| CA-074 | 51049604 | -5.577 |
| Cystatin analog | 3025762 | -5.376 |
| Z-FA-FMK | 16760208 | -5.280 |

📄 Script: [`analysis_scripts/05_docking.sh`](analysis_scripts/05_docking.sh)
📋 Table: [`tables/Table2_docking.csv`](tables/Table2_docking.csv)

### 9. Protein-Ligand Interaction Analysis (PLIP)

| Interaction Type | Residue | Distance |
|---|---|---|
| Parallel π-stacking | TYR137 | 4.28 Å |
| T-shaped π-stacking | PHE56 | 5.11 Å |
| Hydrogen bond | ASP126 | 4.08 Å |
| Hydrophobic | PHE56, TYR137, PHE144 | 3.47-3.61 Å |

📋 Table: [`tables/Table3_plip_interactions.csv`](tables/Table3_plip_interactions.csv)
🖼️ Figure: [`figures/Figure1_docking.png`](figures/Figure1_docking.png)
📄 PyMOL script: [`analysis_scripts/06_visualization.pml`](analysis_scripts/06_visualization.pml)

---

## 🗂️ Repository Structure

```
.
├── README.md                      # Turkish (default)
├── README_EN.md                   # English
├── LICENCE
├── config.yaml                    # Snakemake config
├── environment.yml                # Conda environment
├── suspicious_contigs.txt         # Contaminant contig list
│
├── workflow/                      # Snakemake pipeline
│   ├── Snakefile
│   └── rules/
│       ├── 1_assembly.smk
│       └── 2_annotation.smk
│
├── analysis_scripts/              # Manual commands
│   ├── 01_qc_filter.sh
│   ├── 02_assembly.sh
│   ├── 03_decontamination.sh
│   ├── 04_annotation.sh
│   ├── 05_docking.sh
│   └── 06_visualization.pml
│
├── tables/                        # CSV format tables
│   ├── Table1_contamination.csv
│   ├── Table2_docking.csv
│   └── Table3_plip_interactions.csv
│
├── figures/                       # Visualizations
│   └── Figure1_docking.png
│
└── QC_Raporu/                     # QUAST/QC reports
```

---

## ⚙️ Installation

```bash
git clone https://github.com/dev-bio-emre/BenimGenomum-Hexamita_inflata
cd BenimGenomum-Hexamita_inflata
conda env create -f environment.yml
conda activate genomics
```

To run the pipeline:

```bash
# Snakemake for assembly + annotation
snakemake --cores 4

# Drug discovery steps
bash analysis_scripts/04_annotation.sh
bash analysis_scripts/05_docking.sh
```

---

## 📊 Data Availability

- **Raw data:** NCBI SRA — [ERR11414357](https://www.ncbi.nlm.nih.gov/sra/?term=ERR11414357)
- **Protein structure:** AlphaFold — [A0AA86UFS0](https://alphafold.ebi.ac.uk/entry/A0AA86UFS0)
- **Assembly files:** Not in repo due to size (Git LFS required)

---

## 📄 Publication

> **In Silico Identification of Balicatib as a Potential Inhibitor of *Hexamita inflata* Cathepsin B: An Independent Genome Assembly and Structure-Based Drug Discovery Pipeline**
>
> Emre Engin
> *Preprint coming soon on bioRxiv*

---

## 🙏 Acknowledgements

Heartfelt thanks to **Zeynep Akdeniz** (Data Dreams) and her team for initiating this research direction and for their pioneering work on diplomonad genomics. The reference H. inflata genome used here: Akdeniz et al. (2025) *Scientific Data* — [DOI: 10.1038/s41597-025-04514-x](https://doi.org/10.1038/s41597-025-04514-x)

---

## 👤 Author

**Emre Engin**
ORCID: [0009-0006-1603-7467](https://orcid.org/0009-0006-1603-7467)
GitHub: [@dev-bio-emre](https://github.com/dev-bio-emre)

---

## 📜 License

This project is licensed under the MIT License — see [LICENCE](LICENCE).
