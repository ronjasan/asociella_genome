#!/bin/bash
#SBATCH --ntasks=20
#SBATCH --nodes=2
#SBATCH --mem=50G

conda activate funannotate

out=canu_0.02/funannotate
genome=canu_0.02/purge_haplotigs/WGA_Asoc_correct_clean.fasta.masked.sorted.fa
hybrid=canu_0.02/funannotate/SPAdes/scaffolds.fasta

funannotate train -i ${genome} -o ${out} --species "Aphomia sociella" \
    --cpus 20 --max_intronlen 500000 --trinity ${hybrid} \
    -l RNA_Illumina_Asoc_1.fastq.gz -r RNA_Illumina_Asoc_1.fastq.gz 
