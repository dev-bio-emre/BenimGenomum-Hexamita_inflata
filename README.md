# Hexamita inflata De Novo Genome Assembly Pipeline 🧬

*Diplomonad paraziti Hexamita inflata'nın Oxford Nanopore uzun okuma verileriyle de novo genom montajı ve kapsamlı kalite kontrolü.*

---

## 🛠️ Kullanılan Teknolojiler

| Kategori | Araç |
|---|---|
| İş akışı yönetimi | Snakemake |
| Ham veri QC | NanoPlot, FastQC |
| Filtreleme | Filtlong |
| Genome assembler | Flye |
| Assembly değerlendirme | QUAST, MultiQC |
| Hizalama | Winnowmap, Meryl |
| Kontaminasyon tespiti | BLAST (NCBI), SeqKit |
| Referans karşılaştırması | *Spironucleus salmonicida* (ASM49712v2) |

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
| Tahmini coverage | ~30x |

---

## 🔬 Pipeline Adımları

### 1. Kalite Kontrol
NanoPlot ile ham verinin read uzunluğu dağılımı, kalite skorları ve coverage analizi gerçekleştirildi.

### 2. Filtreleme
Filtlong kullanılarak `--min_length 1000` ve `--min_mean_q 10` parametreleriyle düşük kaliteli ve kısa readler elendi.

| Metrik | Ham | Filtrelenmiş |
|---|---|---|
| Read sayısı | 500,433 | 345,059 |
| Ortalama uzunluk | 9,471 bp | 12,362 bp |
| Ortalama kalite | Q9.6 | Q10.2 |
| >Q10 oranı | %47.7 | %59.6 |
| Toplam baz | 4.7 Gb | 4.3 Gb |

### 3. De Novo Genome Assembly
Flye assembler ile `--genome-size 142m` parametresi kullanılarak de novo montaj gerçekleştirildi.

> **Not:** Bu assembly ham veri (`ERR11414357.fastq`) ile gerçekleştirilmiştir. Filtreleme adımında üretilen `filtered_reads.fastq` (345,059 read, ~27.7x coverage) ile assembly'nin yeniden çalıştırılması ve sonuçların karşılaştırılması planlanmaktadır. Ham veriyle tahmini coverage ~30x, filtrelenmiş veriyle ~27.7x olup uzun read teknolojisinde bu aralık yüksek kaliteli assembly için yeterlidir.

### 4. Assembly Kalite Değerlendirmesi (QUAST)

| Metrik | Hexamita inflata | Referans (S. salmonicida) |
|---|---|---|
| Toplam genom uzunluğu | 154.1 Mb | 14.5 Mb |
| Contig sayısı | 1,243 | — |
| En büyük contig | 3,266,783 bp | — |
| N50 | 324,714 bp | — |
| L50 | 110 | — |
| GC içeriği | %34.57 | %34.15 |
| Genome fraction | %0.002 | — |

### 5. Kontaminasyon Tespiti ve Dekontaminasyon ⚠️

Assembly tamamlandıktan sonra coverage anomali analizi yapıldı. Genomun ortalama 15-40x coverage değerine karşın 9 contigin 100-1016x gibi anormal yüksek coverage sergilediği tespit edildi.

```bash
awk '$3 > 100' assembly_info.txt
```

Bu 9 contigin ilk 300 bazı NCBI BLAST'a gönderildi. Sonuç:

| Contig | Coverage | BLAST Sonucu | Karar |
|---|---|---|---|
| contig_1056 | 1016x | Stenotrophomonas maltophilia | ❌ Çıkarıldı |
| contig_2780 | 556x | Stenotrophomonas maltophilia | ❌ Çıkarıldı |
| contig_2816 | 502x | Stenotrophomonas maltophilia | ❌ Çıkarıldı |
| contig_2793 | 338x | Stenotrophomonas maltophilia | ❌ Çıkarıldı |
| contig_1057 | 334x | Stenotrophomonas maltophilia | ❌ Çıkarıldı |
| contig_805 | 294x | Stenotrophomonas sp. | ❌ Çıkarıldı |
| contig_2794 | 293x | Stenotrophomonas maltophilia | ❌ Çıkarıldı |
| contig_804 | 278x | Stenotrophomonas maltophilia | ❌ Çıkarıldı |
| contig_1059 | 124x | Stenotrophomonas lactitubi | ❌ Çıkarıldı |

9/9 contig *Stenotrophomonas* spp. olarak tanımlandı — kültür kontaminasyonu. SeqKit ile temiz assembly üretildi:

```bash
seqkit grep -v -f suspicious_contigs.txt assembly.fasta.gz > hexamita_clean.fasta
```

**Temiz Assembly Sonucu:**

| Metrik | Ham Assembly | Temiz Assembly |
|---|---|---|
| Contig sayısı | 1,243 | 1,234 |
| Toplam boyut | 154.1 Mb | 149.3 Mb |
| Çıkarılan | — | 4.9 Mb (%3.1) |

---

## 🧫 Biyolojik Yorum

*Hexamita inflata*, diplomonad grubundan bir parazitik protisttir. En yakın sekanslanmış akraba olan *Spironucleus salmonicida* ile genomik mimari (synteny) açısından %0.002 oranında hizalanma, bu iki organizma arasındaki derin evrimsel uzaklaşmayı ortaya koymaktadır. Buna karşın GC oranlarının (%34.57 vs %34.15) yüksek benzerlik göstermesi, temel genomik kompozisyonun korunmuş olduğuna işaret etmektedir.

---

## 🗂️ Repo Yapısı

```
├── workflow/
│   ├── Snakefile
│   ├── rules/
│   │   ├── 1_assembly.smk
│   │   └── 2_annotation.smk
│   └── envs/
├── QC_Raporu/
├── images/
├── config.yaml
└── environment.yml
```

---

## ⚙️ Kurulum ve Çalıştırma

```bash
git clone https://github.com/dev-bio-emre/BenimGenomum-Hexamita_inflata
cd BenimGenomum-Hexamita_inflata
conda env create -f environment.yml
conda activate genomics
snakemake --cores 4
```

---

## 📌 Notlar

- Ham sekans verisi NCBI SRA'dan erişilebilir: `ERR11414357`
- Assembly dosyaları boyut nedeniyle Git LFS veya NCBI'ya yüklenmemiştir
- Annotation adımı (Prodigal, GlimmerHMM, Diamond, EggNOG) devam etmektedir
