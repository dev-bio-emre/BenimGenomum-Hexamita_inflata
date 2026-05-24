# ==============================================================================
# 1_assembly.smk - Düzenlendi ve Dinamik Hale Getirildi
# Tüm sabit yollar silindi, sistem config.yaml'dan okuyacak şekilde ayarlandı.
# ==============================================================================

rule fastqc_before_trimming:
    input:
        # Config dosyasındaki reads yolunu oku
        input_dir=config["samples"]["hexamita_inflata"]["reads"],
    params:
        threads=config.get("threads", 4), # Config'deki cpu sayısını alır,
    output:
        out_dir=directory("results/Genomics/1_Assembly/1_Preprocessing/fastqc_before_trimming/"),
    conda:
        "envs/genomics.yaml",
    script:
        "../../scripts/Genomics/1_Assembly/1_Preprocessing/ReadQualityCheck.py"

# Assembly
rule flye:
    input:
        reads=config["samples"]["hexamita_inflata"]["reads"],
    params:
        genome_size=config.get("genome_size", "142m"), # Config'deki 142m'yi al
        threads=config.get("threads", 4),
    output:
        out_dir= "results/Genomics/1_Assembly/2_Assemblers/flye/{process}/assembly.fasta"
    conda:
        "envs/genomics.yaml"
    script:
        "../../scripts/Genomics/1_Assembly/2_Assemblers/FlyeAssembler.py"

rule setup_nr_db:
    output:
        # Sabit yol kaldırıldı, proje klasörü içine alındı
        outdir = protected(directory("results/databases"))
    conda:
        "envs/genomics.yaml"
    script:
        "../../scripts/Genomics/1_Assembly/3_Evaluation/setup_nr_db.py"

rule blastn:
    input:
        query="results/Genomics/1_Assembly/2_Assemblers/{assembler}/assembly.fasta",
        db="results/databases"
    output:
        "results/Genomics/1_Assembly/3_Evaluation/blastn/{assembler}/{db}/assembly.blastn"
    params:
        outfmt= "6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore qlen slen stitle",
        threads=config.get("threads", 4),
        evalue=1e-10,
        db_prefix="results/databases/{db}"
    conda:
        "envs/genomics.yaml"
    script:
        "../../scripts/Genomics/1_Assembly/3_Evaluation/blastn.py"

rule makeblastdb:
    input:
        "results/Genomics/1_Assembly/2_Assemblers/{assembler}/{db}.fasta"
    output:
        multiext("results/Genomics/1_Assembly/2_Assemblers/{assembler}/]{db}",
            ".ndb",
            ".nhr",
            ".nin",
            ".not",
            ".nsq",
            ".ntf",
            ".nto")
    params:
        outname="results/Genomics/1_Assembly/2_Assemblers/{assembler}/{db}"
    conda:
        "envs/genomics.yaml"
    shell:
        "makeblastdb -in {input} -dbtype nucl -out {params.outname}"


rule blastn_EST:
    input:
        query="resources/RawData/EST_library.fasta", # Dinamikleştirildi
        db="results/Genomics/1_Assembly/2_Assemblers/{assembler}/{db}.ndb"
    output:
        "results/Genomics/1_Assembly/3_Evaluation/blastn/{assembler}/{db}_est.blastn"
    params:
        outfmt= "6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore qlen slen stitle",
        threads=config.get("threads", 4),
        evalue=1e-10,
        db_prefix="results/Genomics/1_Assembly/2_Assemblers/{assembler}/{db}"
    conda:
        "envs/genomics.yaml"
    script:
        "../../scripts/Genomics/1_Assembly/3_Evaluation/blastn.py"

rule meryl:
    input:
        genome="results/Genomics/1_Assembly/2_Assemblers/{assembler}/assembly.fasta",
    output:
        merylDB=directory("results/Genomics/1_Assembly/3_Evaluation/winnowmap/{assembler}/merlyDB"),
        repetitive_k15="results/Genomics/1_Assembly/3_Evaluation/winnowmap/{assembler}/repetitive_k15.txt",
    params:
        threads=config.get("threads", 4),
        nanopore=True
    conda:
        "envs/genomics.yaml"
    script:
        "../../scripts/Genomics/1_Assembly/3_Evaluation/CalculateKmerLongReads.py"

rule winnowmap:
    input:
        genome="results/Genomics/1_Assembly/2_Assemblers/{assembler}/assembly.fasta",
        long_read=config["samples"]["hexamita_inflata"]["reads"], # Config'den okuyor
        merylDB="results/Genomics/1_Assembly/3_Evaluation/winnowmap/{assembler}/merlyDB",
        repetitive_k15="results/Genomics/1_Assembly/3_Evaluation/winnowmap/{assembler}/repetitive_k15.txt",
    output:
        sorted_bam="results/Genomics/1_Assembly/3_Evaluation/winnowmap/{assembler}/nanopore.bam",
    params:
        threads=config.get("threads", 4),
        nanopore=True
    conda:
        "envs/genomics.yaml"
    script:
        "../../scripts/Genomics/1_Assembly/3_Evaluation/MapLongReadsToAssembly.py"

# Evaluation
rule quast:
    input:
        assembly="results/Genomics/1_Assembly/2_Assemblers/{assembler}/assembly.fasta",
    params:
        threads=config.get("threads", 4)
    output:
        report_dir=directory("results/Genomics/1_Assembly/3_Evaluation/quast/{assembler}/")
    conda:
        "envs/genomics.yaml"
    script:
        "../../scripts/Genomics/1_Assembly/3_Evaluation/AssemblyQualityCheck.py"

rule multiqc:
    input:
        # MultiQC'ye, çalışmaya başlamadan önce bu iki adımın bitmesini (ve klasörleri oluşturmasını) emrediyoruz:
        fastqc="results/Genomics/1_Assembly/1_Preprocessing/fastqc_before_trimming/",
        quast="results/Genomics/1_Assembly/3_Evaluation/quast/{assembler}/"
    params:
        search_dir="results/Genomics/1_Assembly/"
    output:
        out_dir=directory("results/Genomics/1_Assembly/3_Evaluation/multiqc/{assembler}")
    conda:
        "envs/genomics.yaml"
    shell:
        'multiqc {params.search_dir} -o {output.out_dir}'

rule plot_coverage_cont:
    input:
        nano="results/Genomics/1_Assembly/3_Evaluation/winnowmap/{assembler}/nanopore.bam"
    output:
        out="results/Genomics/1_Assembly/3_Evaluation/deeptools/{assembler}.png",
        outraw="results/Genomics/1_Assembly/3_Evaluation/deeptools/{assembler}/outRawCounts.txt"
    params:
        threads=config.get("threads", 4),
    conda:
        "envs/genomics.yaml"
    script:
        "../../scripts/Genomics/1_Assembly/3_Evaluation/PlotCoverage.py"