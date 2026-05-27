# Hexamita inflata Drug Discovery Pipeline 🧬💊

> 🇬🇧 [Read in English](README_EN.md)

*From Oxford Nanopore Sequencing to Computational Drug Target Identification*

Diplomonad paraziti **Hexamita inflata**'nın ham sekans verisinden ilaç adayı moleküle uzanan tam bir biyoinformatik pipeline'ı. De novo genom montajı, dekontaminasyon, fonksiyonel annotation, AlphaFold yapı tahmini ve moleküler docking adımlarını içerir.

---

## 🎯 Proje Özeti

```
Ham Veri (Oxford Nanopore)
       ↓
1. Kalite kontrol ve filtreleme (NanoPlot, Filtlong)
       ↓
2. De novo assembly (Flye)
       ↓
3. Kontaminasyon tespiti ve temizleme (BLAST, SeqKit)
       ↓
4. Yapısal & fonksiyonel annotation (Prodigal, Diamond)
       ↓
5. İlaç hedefi seçimi (Cathepsin B)
       ↓
6. Protein yapı tahmini (AlphaFold2, pLDDT: 93.69)
       ↓
7. Bağlanma cebi analizi (fpocket)
       ↓
8. Sanal tarama & moleküler docking (AutoDock Vina)
       ↓
9. Protein-ligand etkileşim analizi (PLIP, PyMOL)
       ↓
🏆 İlaç adayı: Balicatib (-7.027 kcal/mol)
```

---

## 🏆 Ana Bulgu

**Balicatib**, bilinen bir Cathepsin K inhibitörü, *Hexamita inflata* Cathepsin B'ye karşı **-7.027 kcal/mol** bağlanma afinitesi gösterdi — 7 referans inhibitör arasında en yüksek skor.

Anahtar etkileşimler:
- **TYR137** ile parallel π-stacking (4.28 Å) — en güçlü
- **PHE56** ile T-shaped π-stacking (5.11 Å)
- **ASP126** ile hidrojen bağı (4.08 Å)

---

## 🛠️ Kullanılan Teknolojiler

| Aşama | Araç |
|---|---|
| İş akışı yönetimi | Snakemake |
| Ham veri QC | NanoPlot, FastQC |
| Filtreleme | Filtlong |
| Genome assembler | Flye |
| Assembly QC | QUAST, MultiQC |
| Hizalama | Winnowmap, Meryl |
| Kontaminasyon tespiti | BLAST (NCBI), SeqKit |
| Gen tahmini | Prodigal |
| Fonksiyonel annotation | Diamond BLASTP, SwissProt |
| Protein yapı tahmini | AlphaFold2 (EBI) |
| Bağlanma cebi | fpocket |
| Moleküler docking | AutoDock Vina |
| Format dönüşümü | OpenBabel |
| Etkileşim analizi | PLIP |
| Görselleştirme | PyMOL Open-Source |

---

## 📊 Ham Veri Özellikleri (ERR11414357)

| Metrik | Değer |
|---|---|
| Sekans teknolojisi | Oxford Nanopore (Long-Read) |
| Toplam read sayısı | 500,433 |
| Toplam baz | ~4.7 Gb |
| Ortalama read uzunluğu | 9,471 bp |
| Read uzunluğu N50 | 18,889 bp |
| En uzun read | 152,097 bp |
| Ortalama kalite | Q9.6 |

---

## 🔬 Pipeline Adımları

### 1. Kalite Kontrol ve Filtreleme

NanoPlot ile ham verinin değerlendirilmesi, ardından Filtlong ile düşük kaliteli ve kısa readlerin elenmesi.

| Metrik | Ham | Filtrelenmiş |
|---|---|---|
| Read sayısı | 500,433 | 345,059 |
| Ortalama uzunluk | 9,471 bp | 12,362 bp |
| Ortalama kalite | Q9.6 | Q10.2 |
| Toplam baz | 4.7 Gb | 4.3 Gb |
| Tahmini coverage | 30x | 27.7x |

📄 Script: [`analysis_scripts/01_qc_filter.sh`](analysis_scripts/01_qc_filter.sh)

### 2. De Novo Genome Assembly

Flye assembler ile uzun-okuma montajı.

| Metrik | Değer |
|---|---|
| Toplam boyut | 154.1 Mb |
| Contig sayısı | 1,243 |
| En büyük contig | 3,266,783 bp |
| N50 | 324,714 bp |
| L50 | 110 |
| Misassemblies | 0 |
| GC içeriği | %34.57 |

📄 Script: [`analysis_scripts/02_assembly.sh`](analysis_scripts/02_assembly.sh)

### 3. Kontaminasyon Tespiti ve Dekontaminasyon ⚠️

Coverage anomali analizi ile **9 Stenotrophomonas spp. contigi** tespit edildi (toplam 4.9 Mb, %3.1 kontaminasyon).

| Metrik | Ham | Temiz |
|---|---|---|
| Contig sayısı | 1,243 | 1,234 |
| Toplam boyut | 154.1 Mb | 149.3 Mb |
| GC içeriği | %34.57 | %33.53 |

📄 Script: [`analysis_scripts/03_decontamination.sh`](analysis_scripts/03_decontamination.sh)
📋 Tablo: [`tables/Table1_contamination.csv`](tables/Table1_contamination.csv)

### 4. Yapısal ve Fonksiyonel Annotation

Prodigal (genetik kod 6, diplomonad alternative code) ile 27,312 protein tahmini, Diamond BLASTP ile 2,691 protein için fonksiyonel annotation.

En çok eşleşen organizmalar:
- *Arabidopsis thaliana* (n=281)
- *Dictyostelium discoideum* (n=216)
- *Giardia intestinalis* (n=162) ← evrimsel yakınlık doğrulandı

📄 Script: [`analysis_scripts/04_annotation.sh`](analysis_scripts/04_annotation.sh)

### 5. İlaç Hedefi Seçimi: Cathepsin B

Diplomonad parazitlerinde virulans faktörü olarak bilinen Cathepsin B-like sistein proteazı hedef olarak seçildi. En güçlü aday: `contig_1287_94` (%49.4 identity, E-value: 4.15e-81 vs Giardia CP3).

### 6. Protein Yapı Tahmini (AlphaFold2)

UniProt: **A0AA86UFS0**
- 287 amino asit
- **pLDDT: 93.69** (very high confidence)
- İlk yapısal model (PDB'de deneysel yapı yok)

🔗 [AlphaFold sayfası](https://alphafold.ebi.ac.uk/entry/A0AA86UFS0)

### 7. Bağlanma Cebi Analizi

fpocket v4.0 ile 16 cep tespit edildi. En iyi cep:
- Druggability score: **0.77**
- Hacim: 846 Å³
- Cys ve His içeriyor → katalitik triad ✅

### 8. Sanal Tarama ve Moleküler Docking

7 bilinen sistein proteaz inhibitörü AutoDock Vina ile tarandı.

| Bileşik | PubChem CID | Binding Affinity (kcal/mol) |
|---|---|---|
| **Balicatib** ⭐ | 44450571 | **-7.027** |
| Odanacatib | 5347510 | -6.339 |
| E-64 | 9576072 | -6.048 |
| Leupeptin | 5311272 | -5.977 |
| CA-074 | 51049604 | -5.577 |
| Cystatin analog | 3025762 | -5.376 |
| Z-FA-FMK | 16760208 | -5.280 |

📄 Script: [`analysis_scripts/05_docking.sh`](analysis_scripts/05_docking.sh)
📋 Tablo: [`tables/Table2_docking.csv`](tables/Table2_docking.csv)

### 9. Protein-Ligand Etkileşim Analizi (PLIP)

| Etkileşim Türü | Residue | Mesafe |
|---|---|---|
| Parallel π-stacking | TYR137 | 4.28 Å |
| T-shaped π-stacking | PHE56 | 5.11 Å |
| Hydrogen bond | ASP126 | 4.08 Å |
| Hydrophobic | PHE56, TYR137, PHE144 | 3.47-3.61 Å |

📋 Tablo: [`tables/Table3_plip_interactions.csv`](tables/Table3_plip_interactions.csv)
🖼️ Görsel: [`figures/Figure1_docking.png`](figures/Figure1_docking.png)
📄 PyMOL script: [`analysis_scripts/06_visualization.pml`](analysis_scripts/06_visualization.pml)

---

## 🗂️ Repo Yapısı

```
.
├── README.md
├── LICENCE
├── config.yaml                    # Snakemake config
├── environment.yml                # Conda environment
├── suspicious_contigs.txt         # Kontaminant contig listesi
│
├── workflow/                      # Snakemake pipeline
│   ├── Snakefile
│   └── rules/
│       ├── 1_assembly.smk
│       └── 2_annotation.smk
│
├── analysis_scripts/              # Manuel komutlar
│   ├── 01_qc_filter.sh
│   ├── 02_assembly.sh
│   ├── 03_decontamination.sh
│   ├── 04_annotation.sh
│   ├── 05_docking.sh
│   └── 06_visualization.pml
│
├── tables/                        # CSV format tablolar
│   ├── Table1_contamination.csv
│   ├── Table2_docking.csv
│   └── Table3_plip_interactions.csv
│
├── figures/                       # Görseller
│   └── Figure1_docking.png
│
└── QC_Raporu/                     # QUAST/QC raporları
```

---

## ⚙️ Kurulum

```bash
git clone https://github.com/dev-bio-emre/BenimGenomum-Hexamita_inflata
cd BenimGenomum-Hexamita_inflata
conda env create -f environment.yml
conda activate genomics
```

Pipeline'ı çalıştırmak için:

```bash
# Snakemake ile assembly + annotation
snakemake --cores 4

# Drug discovery adımları için
bash analysis_scripts/04_annotation.sh
bash analysis_scripts/05_docking.sh
```

---

## 📊 Veri Erişilebilirliği

- **Ham veri:** NCBI SRA — [ERR11414357](https://www.ncbi.nlm.nih.gov/sra/?term=ERR11414357)
- **Protein yapısı:** AlphaFold — [A0AA86UFS0](https://alphafold.ebi.ac.uk/entry/A0AA86UFS0)
- **Assembly dosyaları:** Boyut nedeniyle repo'da yer almıyor (Git LFS gerekli)

---

## 📄 Makale

> **In Silico Identification of Balicatib as a Potential Inhibitor of *Hexamita inflata* Cathepsin B: A De Novo Genome Assembly, Structural Prediction, and Molecular Docking Study**
>
> Emre Engin
> *Preprint coming soon on bioRxiv*

---

## 🙏 Teşekkür

Bu projeye başlamamı sağlayan ve diplomonad genomiği üzerine öncü çalışmaları için **Zeynep Akdeniz** (Data Dreams) ve ekibine teşekkürlerimi sunarım. Referans olarak kullanılan H. inflata genomu için bkz: Akdeniz et al. (2025) *Scientific Data* — [DOI: 10.1038/s41597-025-04514-x](https://doi.org/10.1038/s41597-025-04514-x)

---

## 👤 Yazar

**Emre Engin**
ORCID: [0009-0006-1603-7467](https://orcid.org/0009-0006-1603-7467)
GitHub: [@dev-bio-emre](https://github.com/dev-bio-emre)

---

## 📜 Lisans

Bu proje MIT lisansı ile lisanslanmıştır — bkz. [LICENCE](LICENCE).

