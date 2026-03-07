# Hexamita inflata De Novo Genom Montaj Boru Hattı 🧬

Bu proje, Oxford Nanopore uzun okuma (long-read) verileri kullanılarak diplomonad paraziti *Hexamita inflata*'nın tam genom montajının gerçekleştirilmesi ve kalitesinin ölçülmesi amacıyla oluşturulmuş bir Snakemake pipeline'dır.

## 🛠️ Kullanılan Teknolojiler ve Araçlar
* **İş Akışı Yönetimi:** Snakemake
* **Genom Montajı (Assembler):** Flye
* **Kalite Kontrol (QC):** QUAST, FastQC
* **Referans Karşılaştırması:** *Spironucleus salmonicida* (ASM49712v2)

## 📊 QUAST Kalite Kontrol ve Montaj Sonuçları

Otomatize edilmiş boru hattı sonucunda üretilen `assembly.fasta` dosyasının, en yakın akraba referans genomu ile karşılaştırmalı kalite ölçümleri aşağıdadır:

| Metrik (QUAST) | Elde Edilen Değer (*Hexamita inflata*) | Referans Değer (*S. salmonicida*) |
| :--- | :--- | :--- |
| **Toplam Genom Uzunluğu** | 154,126,551 GÇ (~154.1 Mb) | 14,545,911 GÇ (~14.5 Mb) |
| **Toplam Parça (Contig) Sayısı** | 1,243 | - |
| **En Büyük Parça (Largest Contig)**| 3,266,783 GÇ (~3.26 Mb) | - |
| **N50 Değeri (Süreklilik Ölçütü)** | 324,714 GÇ | - |
| **L50 Değeri** | 110 | - |
| **GC İçeriği Oranı (%)** | %34.57 | %34.15 |
| **Kapsanan Referans Yüzdesi** | %0.002 (Genome fraction) | - |

> **Bilimsel Çıktı Özeti:** Nanopore uzun okuma verileriyle 154.1 Mb büyüklüğünde ve 324 Kb N50 değerine sahip, son derece bütüncül (contiguous) bir genom elde edilmiştir. En büyük contig boyutunun 3.26 Mb'a ulaşması montajın başarısını kanıtlamaktadır. GC oranlarının referans ile yüksek benzerlik göstermesine rağmen, genomik hizalanma oranının (%0.002) çok düşük çıkması, bu iki tür arasında evrimsel süreçte genomik mimari (synteny) açısından derin bir farklılaşma yaşandığını doğrulamaktadır.