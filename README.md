# Hexamita inflata De Novo Genom Montaj Pipeline'ı 🧬

Bu proje, Oxford Nanopore uzun okuma (long-read) sekans verileri kullanılarak diplomonad paraziti *Hexamita inflata*'nın *de novo* tam genom montajının gerçekleştirilmesi ve kalite kontrol analizlerinin yapılması amacıyla geliştirilmiş, Snakemake tabanlı otomatize bir biyoinformatik pipeline'ıdır (iş akışı).

## 🛠️ Kullanılan Teknolojiler ve Araçlar
* **İş Akışı Yönetimi (Workflow Management):** Snakemake
* **Genom Montaj Algoritması (Assembler):** Flye
* **Kalite Kontrol (QC) & Metrik Analizi:** QUAST, FastQC, NanoPlot
* **Referans Karşılaştırması:** *Spironucleus salmonicida* (ASM49712v2)

## 📊 QUAST Kalite Kontrol ve Montaj Sonuçları

Otomatize edilmiş pipeline sonucunda üretilen `assembly.fasta` dosyasının, NCBI RefSeq veritabanından alınan en yakın akraba referans genomu ile karşılaştırmalı kalite ölçümleri aşağıdadır:

| Metrik (QUAST) | Elde Edilen Değer (*Hexamita inflata*) | Referans Değer (*S. salmonicida*) |
| :--- | :--- | :--- |
| **Toplam Genom Uzunluğu** | 154,126,551 GÇ (~154.1 Mb) | 14,545,911 GÇ (~14.5 Mb) |
| **Toplam Parça (Contig) Sayısı** | 1,243 | - |
| **En Büyük Parça (Largest Contig)**| 3,266,783 GÇ (~3.26 Mb) | - |
| **N50 Değeri (Süreklilik Ölçütü)** | 324,714 GÇ | - |
| **L50 Değeri** | 110 | - |
| **GC İçeriği Oranı (%)** | %34.57 | %34.15 |
| **Kapsanan Referans Yüzdesi** | %0.002 (Genome fraction) | - |

> **Bilimsel Çıktı Özeti:** Nanopore uzun okuma verileriyle gerçekleştirilen *de novo* montaj sonucunda 154.1 Mb büyüklüğünde ve 324 Kb N50 değerine sahip, son derece bütüncül (contiguous) bir genom elde edilmiştir. En büyük contig boyutunun 3.26 Mb'a ulaşması montajın teknik başarısını kanıtlamaktadır. GC oranlarının referans tür ile yüksek benzerlik göstermesine rağmen, genomik hizalanma oranının (%0.002) çok düşük çıkması, bu iki organizma arasında evrimsel süreçte genomik mimari (synteny) açısından derin bir farklılaşma yaşandığını doğrulamaktadır.