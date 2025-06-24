#!/bin/bash
#SBATCH --ntasks=20
#SBATCH --nodes=2
#SBATCH --mem=50G

conda activate funannotate

out=canu_0.02/funannotate
genome=canu_0.02/purge_haplotigs/WGA_Asoc_correct_clean.fasta.masked.sorted.fa

funannotate predict -i ${genome} -o ${out} --species "Aphomia sociella" \
    --cpus 10 --max_intronlen 500000 \
    --organism other --optimize_augustus --weights codingquarry:0 \
    --busco_db lepidoptera_odb10
