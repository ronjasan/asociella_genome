#!/bin/bash
#SBATCH --ntasks=10             
#SBATCH --nodes=1   
#SBATCH --mem=30G

conda activate SPAdes

out=canu_0.02/funannotate/SPAdes

spades.py --rna -1 RNA_Illumina_Asoc_1.fastq.gz -2 RNA_Illumina_Asoc_2.fastq.gz \
    --nanopore RNA_ONT_Asoc.fastq.gz -o ${out} 
