#!/bin/bash
#SBATCH --ntasks=20
#SBATCH --nodes=2
#SBATCH --mem=50G

conda activate funannotate

in=canu_0.02/funannotate
out=canu_0.02/funannotate
eggnog_db=/glittertind/shared_databases/eggnog

funannotate annotate -i ${in} -o ${out} --species "Aphomia sociella" --cpus 16 
