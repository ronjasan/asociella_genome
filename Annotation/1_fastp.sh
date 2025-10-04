#!/bin/bash
#SBATCH --ntasks=10             
#SBATCH --nodes=1   
#SBATCH --mem=30G

conda activate fastp

fastp -i RNAseq/SRR34022945_R1.fastq \
-I RNAseq/SRR34022945_R2.fastq \
-o RNAseq/SRR34022945_fastp_R1.fastq \
-O RNAseq/SRR34022945_fastp_R2.fastq

fastplong -i RNAseq/SRR34022944.fastq \
-o RNAseq/SRR34022944_fastplong.fastq